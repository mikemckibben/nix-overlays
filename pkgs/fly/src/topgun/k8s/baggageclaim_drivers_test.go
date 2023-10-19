package k8s_test

import (
	"fmt"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	corev1 "k8s.io/api/core/v1"
	v1 "k8s.io/api/storage/v1"
	k8sErrs "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/api/resource"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

var _ = Describe("baggageclaim drivers", func() {

	AfterEach(func() {
		cleanupReleases()
	})

	onPks(func() {
		baggageclaimWorks("btrfs")
		baggageclaimWorks("overlay")
		baggageclaimWorks("naive")
	})

	onGke(func() {

		const (
			COS    = "--set=worker.nodeSelector.nodeImage=cos"
			UBUNTU = "--set=worker.nodeSelector.nodeImage=ubuntu"
		)

		Context("cos image", func() {
			baggageclaimFails("btrfs", COS)
			baggageclaimWorks("overlay", COS)
			baggageclaimWorks("naive", COS)
		})

		Context("ubuntu image", func() {
			baggageclaimWorks("btrfs", UBUNTU)
			baggageclaimWorks("overlay", UBUNTU)
			baggageclaimWorks("naive", UBUNTU)
		})

		Context("with a real btrfs partition", func() {
			It("successfully recreates the worker", func() {
				By("deploying concourse with ONLY one worker and having the worker pod use the gcloud disk and format it with btrfs")

				scName := "btrfs"
				createBtrfsStorageClass(scName)

				setReleaseNameAndNamespace("real-btrfs-disk")
				pvcName := "disk-" + namespace

				deployWithDriverAndSelectors("btrfs", UBUNTU,
					"--set=persistence.enabled=false",
					"--set=worker.additionalVolumes[0].name=concourse-work-dir",
					"--set=worker.additionalVolumes[0].persistentVolumeClaim.claimName="+pvcName,
				)

				// We create the PVC after deploying because we need the namespace to be created first by helm
				createPVC(pvcName, scName)

				atc := waitAndLogin(namespace, releaseName+"-web")
				defer atc.Close()

				By("Setting and triggering a pipeline that always fails which creates volumes on the persistent disk")
				fly.Run("set-pipeline", "-n", "-c", "pipelines/pipeline-that-fails.yml", "-p", "failing-pipeline")
				fly.Run("unpause-pipeline", "-p", "failing-pipeline")
				sessionTriggerJob := fly.Start("trigger-job", "-w", "-j", "failing-pipeline/simple-job")
				<-sessionTriggerJob.Exited

				By("deleting the worker pod which triggers the initContainer script")
				deletePods(releaseName, fmt.Sprintf("--selector=app=%s-worker", releaseName))

				By("all pods should be running")
				waitAllPodsInNamespaceToBeReady(namespace)
			})
		})

	})
})

func baggageclaimWorks(driver string, selectorFlags ...string) {
	Context(driver, func() {
		It("works", func() {
			setReleaseNameAndNamespace("bd-" + driver)
			deployWithDriverAndSelectors(driver, selectorFlags...)

			atc := waitAndLogin(namespace, releaseName+"-web")
			defer atc.Close()

			By("Setting and triggering a dumb pipeline")
			fly.Run("set-pipeline", "-n", "-c", "pipelines/get-task.yml", "-p", "some-pipeline")
			fly.Run("unpause-pipeline", "-p", "some-pipeline")
			fly.Run("trigger-job", "-w", "-j", "some-pipeline/simple-job")
		})
	})
}

func baggageclaimFails(driver string, selectorFlags ...string) {
	Context(driver, func() {
		It("fails", func() {
			setReleaseNameAndNamespace("bd-" + driver)
			deployWithDriverAndSelectors(driver, selectorFlags...)

			Eventually(func() []byte {
				var logs []byte
				pods := getPods(namespace, metav1.ListOptions{LabelSelector: "app=" + namespace + "-worker"})
				for _, p := range pods {
					contents, _ := kubeClient.CoreV1().Pods(namespace).GetLogs(p.Name, &corev1.PodLogOptions{}).Do().Raw()
					logs = append(logs, contents...)
				}

				return logs

			}, 2*time.Minute, 1*time.Second).Should(ContainSubstring("failed-to-set-up-driver"))
		})
	})
}

func deployWithDriverAndSelectors(driver string, selectorFlags ...string) {
	helmDeployTestFlags := []string{
		"--set=concourse.web.kubernetes.enabled=false",
		"--set=concourse.worker.baggageclaim.driver=" + driver,
		"--set=worker.replicas=1",
	}

	deployConcourseChart(releaseName, append(helmDeployTestFlags, selectorFlags...)...)
}

func createBtrfsStorageClass(name string) {
	_, err := kubeClient.StorageV1().StorageClasses().Create(&v1.StorageClass{
		ObjectMeta:  metav1.ObjectMeta{Name: "btrfs"},
		Provisioner: "kubernetes.io/gce-pd",
		Parameters: map[string]string{
			"type":   "pd-standard",
			"fstype": name,
		},
	})
	if err != nil && !k8sErrs.IsAlreadyExists(err) {
		Fail("failed to create btrfs storage class: " + err.Error())
	}
}
func createPVC(name string, scName string) {
	_, err := kubeClient.CoreV1().PersistentVolumeClaims(namespace).
		Create(&corev1.PersistentVolumeClaim{
			ObjectMeta: metav1.ObjectMeta{Name: name, Namespace: namespace},
			Spec: corev1.PersistentVolumeClaimSpec{
				StorageClassName: &scName,
				AccessModes:      []corev1.PersistentVolumeAccessMode{corev1.ReadWriteOnce},
				Resources: corev1.ResourceRequirements{Requests: corev1.ResourceList{
					corev1.ResourceStorage: resource.MustParse("1Gi")}},
			}})
	Expect(err).To(BeNil(), "failed to create persistent volume claim "+name)
}
