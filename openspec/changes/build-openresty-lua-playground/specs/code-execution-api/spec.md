# Spec Delta

## Purpose

Exposes an HTTP API endpoint to receive, validate, and execute Lua code snippets and return JSON execution responses.

## ADDED Requirements

### Requirement: HTTP Method and Content Validation
The system SHALL restrict the `/run` endpoint to HTTP POST requests and validate that a non-empty code parameter is supplied.

#### Scenario: Disallowing non-POST requests
- **WHEN** client sends a GET, PUT, or DELETE request to `/run`
- **THEN** system responds with HTTP status 405 and a JSON object containing an error message

#### Scenario: Missing or empty code payload
- **WHEN** client submits a POST request to `/run` with an empty or missing code parameter
- **THEN** system responds with HTTP status 400 and a JSON object containing an error message

### Requirement: Code Payload Size Constraint
The system SHALL enforce a maximum allowed script source size of 16,384 bytes (16 KB).

#### Scenario: Payload exceeds size threshold
- **WHEN** client submits code longer than 16,384 bytes
- **THEN** system responds with HTTP status 400 and a JSON object indicating the code exceeds the maximum allowed size

### Requirement: JSON Response Formatting
The system SHALL return execution responses formatted as JSON with `application/json; charset=utf-8` headers containing output on success or error details on failure.

#### Scenario: Successful script execution response
- **WHEN** script compiles and runs to completion without errors
- **THEN** system responds with HTTP status 200 and a JSON body containing the captured output in the output property

#### Scenario: Failed script execution response
- **WHEN** script fails during compilation or runtime execution
- **THEN** system responds with HTTP status 200 and a JSON body containing the failure details in the error property
