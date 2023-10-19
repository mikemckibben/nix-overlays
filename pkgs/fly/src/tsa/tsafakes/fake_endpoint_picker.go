// Code generated by counterfeiter. DO NOT EDIT.
package tsafakes

import (
	"sync"

	"github.com/concourse/concourse/tsa"
	"github.com/tedsuo/rata"
)

type FakeEndpointPicker struct {
	PickStub        func() *rata.RequestGenerator
	pickMutex       sync.RWMutex
	pickArgsForCall []struct {
	}
	pickReturns struct {
		result1 *rata.RequestGenerator
	}
	pickReturnsOnCall map[int]struct {
		result1 *rata.RequestGenerator
	}
	invocations      map[string][][]interface{}
	invocationsMutex sync.RWMutex
}

func (fake *FakeEndpointPicker) Pick() *rata.RequestGenerator {
	fake.pickMutex.Lock()
	ret, specificReturn := fake.pickReturnsOnCall[len(fake.pickArgsForCall)]
	fake.pickArgsForCall = append(fake.pickArgsForCall, struct {
	}{})
	fake.recordInvocation("Pick", []interface{}{})
	fake.pickMutex.Unlock()
	if fake.PickStub != nil {
		return fake.PickStub()
	}
	if specificReturn {
		return ret.result1
	}
	fakeReturns := fake.pickReturns
	return fakeReturns.result1
}

func (fake *FakeEndpointPicker) PickCallCount() int {
	fake.pickMutex.RLock()
	defer fake.pickMutex.RUnlock()
	return len(fake.pickArgsForCall)
}

func (fake *FakeEndpointPicker) PickCalls(stub func() *rata.RequestGenerator) {
	fake.pickMutex.Lock()
	defer fake.pickMutex.Unlock()
	fake.PickStub = stub
}

func (fake *FakeEndpointPicker) PickReturns(result1 *rata.RequestGenerator) {
	fake.pickMutex.Lock()
	defer fake.pickMutex.Unlock()
	fake.PickStub = nil
	fake.pickReturns = struct {
		result1 *rata.RequestGenerator
	}{result1}
}

func (fake *FakeEndpointPicker) PickReturnsOnCall(i int, result1 *rata.RequestGenerator) {
	fake.pickMutex.Lock()
	defer fake.pickMutex.Unlock()
	fake.PickStub = nil
	if fake.pickReturnsOnCall == nil {
		fake.pickReturnsOnCall = make(map[int]struct {
			result1 *rata.RequestGenerator
		})
	}
	fake.pickReturnsOnCall[i] = struct {
		result1 *rata.RequestGenerator
	}{result1}
}

func (fake *FakeEndpointPicker) Invocations() map[string][][]interface{} {
	fake.invocationsMutex.RLock()
	defer fake.invocationsMutex.RUnlock()
	fake.pickMutex.RLock()
	defer fake.pickMutex.RUnlock()
	copiedInvocations := map[string][][]interface{}{}
	for key, value := range fake.invocations {
		copiedInvocations[key] = value
	}
	return copiedInvocations
}

func (fake *FakeEndpointPicker) recordInvocation(key string, args []interface{}) {
	fake.invocationsMutex.Lock()
	defer fake.invocationsMutex.Unlock()
	if fake.invocations == nil {
		fake.invocations = map[string][][]interface{}{}
	}
	if fake.invocations[key] == nil {
		fake.invocations[key] = [][]interface{}{}
	}
	fake.invocations[key] = append(fake.invocations[key], args)
}

var _ tsa.EndpointPicker = new(FakeEndpointPicker)
