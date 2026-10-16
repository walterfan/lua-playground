# Spec Delta

## Purpose

Provides an isolated in-memory Lua runtime environment that whitelists safe libraries, captures standard output, and limits CPU execution steps.

## ADDED Requirements

### Requirement: Sandboxed Environment Whitelisting
The system SHALL restrict executing Lua code to a whitelist of safe built-ins and standard libraries while excluding access to operating system, filesystem, module loading, and FFI APIs.

#### Scenario: Running whitelisted math and string operations
- **WHEN** user code invokes functions in `math`, `string`, `table`, or safe built-ins (`pairs`, `ipairs`, `tonumber`, `tostring`, `type`)
- **THEN** the script executes successfully and produces the expected computation results

#### Scenario: Blocking access to dangerous globals
- **WHEN** user code attempts to call or access `os`, `io`, `require`, `package`, `dofile`, `loadfile`, `loadstring`, `debug`, or `ffi`
- **THEN** the script evaluates those symbols as nil or fails with an error indicating forbidden capability

### Requirement: Output Capture
The system SHALL override `print()` inside the sandboxed environment to capture printed values into an internal buffer.

#### Scenario: Capturing printed values
- **WHEN** user code calls `print()` with one or more values
- **THEN** values are converted to strings, concatenated with tabs, and saved as lines in the execution output buffer

### Requirement: Instruction Limit Enforcement
The system SHALL enforce a cooperative execution instruction limit to abort runaway loops or excessive CPU usage.

#### Scenario: Terminating infinite execution loops
- **WHEN** user code runs an unbounded or infinite loop
- **THEN** execution is interrupted by the instruction hook and returns an execution timeout error
