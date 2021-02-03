"""
Module used to test the administrative endpoints for the api.
"""

import os
import pytest
import requests


@pytest.mark.integration
@pytest.mark.system
@pytest.mark.AdminEndpoints
class TestAdminEndpoints:
    """
    Class used to test the administrative endpoints for the api.
    """

    __ENVIRONMENT_ENV_VARIABLE = "environment"
    __DEFAULT_ENVIRONMENT_VALUE = "localhost"
    __ENVIRONMENT = os.getenv(
        __ENVIRONMENT_ENV_VARIABLE,
        __DEFAULT_ENVIRONMENT_VALUE
    )

    @pytest.fixture()
    def admin_host_url(self) -> str:
        """
        Return the admin url for the api.
        """
        if self.__ENVIRONMENT == "localhost":
            yield "http://localhost:9001"
            return
        if self.__ENVIRONMENT == "docker":
            yield "http://clickandobey-golang-dockerized-webservice-app:9001"
            return

        raise ValueError(f"Unexpected environment value {self.__ENVIRONMENT}")

    def test_configuration(self, admin_host_url: str):
        """
        Test to ensure the configuration endpoint comes back as expected.
        """
        response = requests.get(f"{admin_host_url}/admin/configuration")
        response.raise_for_status()
        assert response.status_code == 200, "Failed to get the correct response code from the configuration request."

        configuration = response.json()
        assert configuration, "Failed to get a configuration."
        assert len(configuration) != 0, "Failed to find keys in the configuration dict."

    def test_status(self, admin_host_url: str):
        """
        Test to ensure the status endpoint comes back as expected.
        """
        response = requests.get(f"{admin_host_url}/admin/status")
        response.raise_for_status()
        assert response.status_code == 200, "Failed to get the correct response code from the configuration request."

        status = response.json()
        assert status["Running"], "Failed to get the correct status."
