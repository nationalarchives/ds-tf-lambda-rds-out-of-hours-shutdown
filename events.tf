resource "aws_cloudwatch_event_rule" "nightly_shutdown" {
    name                = "RDS-Nightly-ShutDown"
    description         = "Invokes Lambda to shutdown listed RDS instances in Rule configuration"
    schedule_expression = "cron(0 19 * * ? *)"

    tags = {
        Environment = var.environment
        Service     = var.service
        CostCentre  = var.cost_centre
        Owner       = var.owner
        CreatedBy   = var.created_by
        Terraform   = true
    }
}

resource "aws_cloudwatch_event_target" "nightly_shutdown" {
    rule      = aws_cloudwatch_event_rule.nightly_shutdown.name
    target_id = "lambda"
    arn       = aws_lambda_function.rds_out_of_hours_shutdown.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_nightly_shutdown" {
    statement_id  = "AllowNightlyShutDownExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.rds_out_of_hours_shutdown.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.nightly_shutdown.arn
}

resource "aws_cloudwatch_event_rule" "morning_startup" {
    name                = "RDS-Morning-StartUp"
    description         = "Invokes Lambda to start listed RDS instances in Rule configuration"
    schedule_expression = "cron(0 7 * * ? *)"

    tags = {
        Environment = var.environment
        Service     = var.service
        CostCentre  = var.cost_centre
        Owner       = var.owner
        CreatedBy   = var.created_by
        Terraform   = true
    }
}

resource "aws_cloudwatch_event_target" "morning_startup" {
    rule      = aws_cloudwatch_event_rule.morning_startup.name
    target_id = "lambda"
    arn       = aws_lambda_function.rds_out_of_hours_shutdown.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_morning_startup" {
    statement_id  = "AllowMorningStartUpExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.rds_out_of_hours_shutdown.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.morning_startup.arn
}
