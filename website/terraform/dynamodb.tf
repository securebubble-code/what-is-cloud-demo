# create a dynamodb table for dynamic web data
resource "aws_dynamodb_table" "main-website-table" {
  name         = "main-website-table"
  hash_key     = "Data1"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "Data1"
    type = "S"
  }
  lifecycle {
    ignore_changes  = [name]
  }
}

resource "aws_dynamodb_table_item" "main-website-table-item-01" {
  table_name = aws_dynamodb_table.main-website-table.name
  hash_key   = aws_dynamodb_table.main-website-table.hash_key

  item = <<ITEM
{
  "Data1": {"S": "Interesting"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM
}