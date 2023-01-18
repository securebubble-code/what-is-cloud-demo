# create a dynamodb table for dynamic web data
resource "aws_dynamodb_table" "main-website-table" {
  name         = "main-website-table"
  hash_key     = "Subject"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "Subject"
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
  "Subject": {"S": "antony"},
  "colour": {"S": "blue"},
  "sport": {"S": "formula_one"},
  "animal": {"S": "dogs"},
  "cloud": {"S": "couldn't possibly say ;)"}
}
ITEM
}

resource "aws_dynamodb_table_item" "main-website-table-item-02" {
  table_name = aws_dynamodb_table.main-website-table.name
  hash_key   = aws_dynamodb_table.main-website-table.hash_key

  item = <<ITEM
{
  "Subject": {"S": "sherlock"},
  "colour": {"S": "pink"},
  "sport": {"S": "the game"},
  "animal": {"S": "hounds"},
  "cloud": {"S": "the cloud of death"}
}
ITEM
}