package admin

import (
	"testing"
)

func TestGetConfiguration(t *testing.T) {
	configuration := GetConfiguration()
	if configuration.Environment != "localhost" {
		t.Errorf("Expected environment of localhost, got %s", configuration.Environment)
	}

	if configuration.Version != "1.0.0" {
		t.Errorf("Expected version of 1.0.0, got %s", configuration.Version)
	}

	if configuration.Debug {
		t.Errorf("Expected debug of false, got %t", configuration.Debug)
	}
}