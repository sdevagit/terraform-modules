output vpc_id {
  value = "${aws_vpc.myvpc.id}"
}

output vpc_cidr {
  value = "${aws_vpc.myvpc.cidr_block}"
}

output subnet_private_a_id {
  value = "${aws_subnet.private-a.id}"
}

output subnets_private {
  value = ["${aws_subnet.private-a.id}", "${aws_subnet.private-b.id}", "${aws_subnet.private-c.id}"]
}

output subnets_private_reversed {
  value = ["${aws_subnet.private-c.id}", "${aws_subnet.private-b.id}", "${aws_subnet.private-a.id}"]
}
