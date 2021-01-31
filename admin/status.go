package admin

type Status struct {
	Running bool
}

func GetStatus() Status {
	status := Status{true}
	return status
}
