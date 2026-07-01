resource "aws_security_group" "eks_cluster" {

  name = "${var.cluster_name}-cluster"

  vpc_id = aws_vpc.eks.id

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}


resource "aws_security_group" "eks_nodes" {

  name = "${var.cluster_name}-nodes"

  vpc_id = aws_vpc.eks.id

  ingress {

    from_port = 3000

    to_port = 3000

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}