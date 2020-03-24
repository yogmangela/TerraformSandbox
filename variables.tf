variable "server_port" {
  description="Open port 8080 for busybox server"
  type=number
  default=8080
}


variable "nunber_example" {
  description="this is number example in variable"
  type = number
  default = 85
}

variable "list_example" {
  description="this is a list example in variable"
  type =list
  default =["a","g","u","o","y"]
}
variable "list_number_example" {
  description="this is a list number example in variable"
  type =list(number)
  default = [1,2,3,4,5,6]
}
variable "map_example" {
  description="this is a map example in variable"
  type = map(string)
  default ={
      key1="val1"
      key2="val2"
      key3="val3"
  }
}


variable "object_example" {
  description="this is an object and Tuple structure type example in variable"
  type = object({
      name=string
      age=number
      tags=list(string)
      enable=bool
  })
  default ={
      name="mniuyfteaa"
      age=45
      tags=["a","y","a"]
      enable=true
  }
}


variable "object_example_with_error" {
  description="this is an object and Tuple structure type ERROR"
  type = object({
      name=string
      age=number
      tags=list(string)
      enable=bool
  })
  default ={
      name="mniuyfteaa"
      age=45
      tags=["a","y","a"]
      enable=true
  }
}