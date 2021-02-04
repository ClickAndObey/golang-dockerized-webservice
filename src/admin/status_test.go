package admin

import (
	"testing"
)

func TestGetStatus(t *testing.T) {
	status := GetStatus()
	if status.Running != true {
		t.Errorf("Expected running to be true, got %t", status.Running)
	}
}
