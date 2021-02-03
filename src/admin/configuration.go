package admin

type Configuration struct {
	Environment string
	Version string
	Debug bool
}

func GetConfiguration() Configuration {
	configuration := Configuration{"localhost", "1.0.0", false}
	return configuration
}
