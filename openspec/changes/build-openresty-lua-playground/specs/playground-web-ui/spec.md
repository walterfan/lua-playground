# Spec Delta

## Purpose

Provides an interactive browser-based code editing interface and execution results console for Lua scripts.

## ADDED Requirements

### Requirement: Render Playground Page
The system SHALL serve an HTML playground page with a code input textarea, run action button, and an output display panel when requested at the root path.

#### Scenario: Accessing root path
- **WHEN** client sends an HTTP GET request to `/`
- **THEN** system responds with HTTP status 200, Content-Type `text/html; charset=utf-8`, and an HTML document containing the editor form and output container

### Requirement: Asynchronous Code Submission
The client-side interface SHALL submit entered Lua code asynchronously to the execution endpoint without reloading the page and display returned execution results or errors.

#### Scenario: Submitting valid code
- **WHEN** user enters code and triggers the Run button
- **THEN** client submits a POST request to `/run` with the code payload and renders output in the output container

#### Scenario: Handling execution failure response
- **WHEN** client receives an error response or non-200 status code from `/run`
- **THEN** client renders the returned error message in the output container with error highlighting
