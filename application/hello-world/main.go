package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"hello-world/controller"
)

func main() {
	handler := controller.Create()
	lambda.Start(handler.Run)
}
