resource "aws_iam_group" "groups" {
  count = "${length(var.grouplist)}"  
  name = "${element(var.grouplist, count.index)}"
}

resource "aws_iam_user" "users" {  
  count = "${length(var.userlist)}"
  name = "${element(var.userlist,count.index )}"

  depends_on = [aws_iam_group.groups]
}

resource "aws_iam_group_membership" "membership" {
    count = "${length(var.grouplist)}"
    name  = "group-membership-${element(var.grouplist, count.index)}"
    group = "${element(var.grouplist, count.index)}"
    users = "${var.groupmembership[element(var.grouplist,count.index )]}"

    depends_on = [aws_iam_user.users]
}