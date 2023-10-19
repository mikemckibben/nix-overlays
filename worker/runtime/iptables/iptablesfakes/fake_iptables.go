// Code generated by counterfeiter. DO NOT EDIT.
package iptablesfakes

import (
	"sync"

	"github.com/concourse/concourse/worker/runtime/iptables"
)

type FakeIptables struct {
	AppendRuleStub        func(string, string, ...string) error
	appendRuleMutex       sync.RWMutex
	appendRuleArgsForCall []struct {
		arg1 string
		arg2 string
		arg3 []string
	}
	appendRuleReturns struct {
		result1 error
	}
	appendRuleReturnsOnCall map[int]struct {
		result1 error
	}
	CreateChainOrFlushIfExistsStub        func(string, string) error
	createChainOrFlushIfExistsMutex       sync.RWMutex
	createChainOrFlushIfExistsArgsForCall []struct {
		arg1 string
		arg2 string
	}
	createChainOrFlushIfExistsReturns struct {
		result1 error
	}
	createChainOrFlushIfExistsReturnsOnCall map[int]struct {
		result1 error
	}
	invocations      map[string][][]interface{}
	invocationsMutex sync.RWMutex
}

func (fake *FakeIptables) AppendRule(arg1 string, arg2 string, arg3 ...string) error {
	fake.appendRuleMutex.Lock()
	ret, specificReturn := fake.appendRuleReturnsOnCall[len(fake.appendRuleArgsForCall)]
	fake.appendRuleArgsForCall = append(fake.appendRuleArgsForCall, struct {
		arg1 string
		arg2 string
		arg3 []string
	}{arg1, arg2, arg3})
	fake.recordInvocation("AppendRule", []interface{}{arg1, arg2, arg3})
	fake.appendRuleMutex.Unlock()
	if fake.AppendRuleStub != nil {
		return fake.AppendRuleStub(arg1, arg2, arg3...)
	}
	if specificReturn {
		return ret.result1
	}
	fakeReturns := fake.appendRuleReturns
	return fakeReturns.result1
}

func (fake *FakeIptables) AppendRuleCallCount() int {
	fake.appendRuleMutex.RLock()
	defer fake.appendRuleMutex.RUnlock()
	return len(fake.appendRuleArgsForCall)
}

func (fake *FakeIptables) AppendRuleCalls(stub func(string, string, ...string) error) {
	fake.appendRuleMutex.Lock()
	defer fake.appendRuleMutex.Unlock()
	fake.AppendRuleStub = stub
}

func (fake *FakeIptables) AppendRuleArgsForCall(i int) (string, string, []string) {
	fake.appendRuleMutex.RLock()
	defer fake.appendRuleMutex.RUnlock()
	argsForCall := fake.appendRuleArgsForCall[i]
	return argsForCall.arg1, argsForCall.arg2, argsForCall.arg3
}

func (fake *FakeIptables) AppendRuleReturns(result1 error) {
	fake.appendRuleMutex.Lock()
	defer fake.appendRuleMutex.Unlock()
	fake.AppendRuleStub = nil
	fake.appendRuleReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeIptables) AppendRuleReturnsOnCall(i int, result1 error) {
	fake.appendRuleMutex.Lock()
	defer fake.appendRuleMutex.Unlock()
	fake.AppendRuleStub = nil
	if fake.appendRuleReturnsOnCall == nil {
		fake.appendRuleReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.appendRuleReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *FakeIptables) CreateChainOrFlushIfExists(arg1 string, arg2 string) error {
	fake.createChainOrFlushIfExistsMutex.Lock()
	ret, specificReturn := fake.createChainOrFlushIfExistsReturnsOnCall[len(fake.createChainOrFlushIfExistsArgsForCall)]
	fake.createChainOrFlushIfExistsArgsForCall = append(fake.createChainOrFlushIfExistsArgsForCall, struct {
		arg1 string
		arg2 string
	}{arg1, arg2})
	fake.recordInvocation("CreateChainOrFlushIfExists", []interface{}{arg1, arg2})
	fake.createChainOrFlushIfExistsMutex.Unlock()
	if fake.CreateChainOrFlushIfExistsStub != nil {
		return fake.CreateChainOrFlushIfExistsStub(arg1, arg2)
	}
	if specificReturn {
		return ret.result1
	}
	fakeReturns := fake.createChainOrFlushIfExistsReturns
	return fakeReturns.result1
}

func (fake *FakeIptables) CreateChainOrFlushIfExistsCallCount() int {
	fake.createChainOrFlushIfExistsMutex.RLock()
	defer fake.createChainOrFlushIfExistsMutex.RUnlock()
	return len(fake.createChainOrFlushIfExistsArgsForCall)
}

func (fake *FakeIptables) CreateChainOrFlushIfExistsCalls(stub func(string, string) error) {
	fake.createChainOrFlushIfExistsMutex.Lock()
	defer fake.createChainOrFlushIfExistsMutex.Unlock()
	fake.CreateChainOrFlushIfExistsStub = stub
}

func (fake *FakeIptables) CreateChainOrFlushIfExistsArgsForCall(i int) (string, string) {
	fake.createChainOrFlushIfExistsMutex.RLock()
	defer fake.createChainOrFlushIfExistsMutex.RUnlock()
	argsForCall := fake.createChainOrFlushIfExistsArgsForCall[i]
	return argsForCall.arg1, argsForCall.arg2
}

func (fake *FakeIptables) CreateChainOrFlushIfExistsReturns(result1 error) {
	fake.createChainOrFlushIfExistsMutex.Lock()
	defer fake.createChainOrFlushIfExistsMutex.Unlock()
	fake.CreateChainOrFlushIfExistsStub = nil
	fake.createChainOrFlushIfExistsReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeIptables) CreateChainOrFlushIfExistsReturnsOnCall(i int, result1 error) {
	fake.createChainOrFlushIfExistsMutex.Lock()
	defer fake.createChainOrFlushIfExistsMutex.Unlock()
	fake.CreateChainOrFlushIfExistsStub = nil
	if fake.createChainOrFlushIfExistsReturnsOnCall == nil {
		fake.createChainOrFlushIfExistsReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.createChainOrFlushIfExistsReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *FakeIptables) Invocations() map[string][][]interface{} {
	fake.invocationsMutex.RLock()
	defer fake.invocationsMutex.RUnlock()
	fake.appendRuleMutex.RLock()
	defer fake.appendRuleMutex.RUnlock()
	fake.createChainOrFlushIfExistsMutex.RLock()
	defer fake.createChainOrFlushIfExistsMutex.RUnlock()
	copiedInvocations := map[string][][]interface{}{}
	for key, value := range fake.invocations {
		copiedInvocations[key] = value
	}
	return copiedInvocations
}

func (fake *FakeIptables) recordInvocation(key string, args []interface{}) {
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

var _ iptables.Iptables = new(FakeIptables)
