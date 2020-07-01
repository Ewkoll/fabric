/*
Copyright IBM Corp. All Rights Reserved.

SPDX-License-Identifier: Apache-2.0
*/

package semaphore_test

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/hyperledger/fabric/common/semaphore"
	. "github.com/onsi/gomega"
	"github.com/stretchr/testify/assert"
)

func TestNewSemaphorePanic(t *testing.T) {
	assert.PanicsWithValue(t, "count must be greater than 0", func() { semaphore.New(0) })
}

func TestSemaphoreBlocking(t *testing.T) {
	gt := NewGomegaWithT(t)

	sema := semaphore.New(5)
	for i := 0; i < 5; i++ {
		err := sema.Acquire(context.Background())
		gt.Expect(err).NotTo(HaveOccurred())
	}

	done := make(chan struct{})
	go func() {
		err := sema.Acquire(context.Background())
		fmt.Println("-------1")
		gt.Expect(err).NotTo(HaveOccurred())
		fmt.Println("-------2")
		close(done)
		fmt.Println("-------3")
		sema.Release()
		fmt.Println("-------4")
	}()

	fmt.Println("-------5")
	gt.Consistently(done).ShouldNot(BeClosed())

	fmt.Println("-------6")
	sema.Release()
	time.Sleep(5 * time.Second)

	fmt.Println("-------7")
	gt.Eventually(done).Should(BeClosed())
	fmt.Println("-------8")
}

func TestSemaphoreContextError(t *testing.T) {
	gt := NewGomegaWithT(t)

	sema := semaphore.New(1)
	err := sema.Acquire(context.Background())
	gt.Expect(err).NotTo(HaveOccurred())

	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	errCh := make(chan error, 1)
	go func() { errCh <- sema.Acquire(ctx) }()

	gt.Eventually(errCh).Should(Receive(Equal(context.Canceled)))
}

func TestSemaphoreReleaseTooMany(t *testing.T) {
	sema := semaphore.New(1)
	assert.PanicsWithValue(t, "semaphore buffer is empty", func() { sema.Release() })
}
