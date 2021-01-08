data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/lambda"
    output_path = "lambda-function.zip"
}

resource "aws_lambda_function" "rds_out_of_hours_shutdown" {
    filename         = "lambda-function.zip"
    function_name    = "rds-out-of-hours-shutdown"
    role             = aws_iam_role.rds_out_of_hours_shutdown.arn
    handler          = "rds_out_of_hours_shutdown.lambda_handler"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime          = "python3.6"

    tags = {
        Environment = var.environment
        Service     = var.service
        CostCentre  = var.cost_centre
        Owner       = var.owner
        CreatedBy   = var.created_by
        Terraform   = true
    }
}
