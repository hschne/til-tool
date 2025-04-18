#!/usr/bin/env bats

# Source the til script to access its functions directly
setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  export TEST_TMP_DIR="$(mktemp -d)"
  export TIL_FOLDER="$TEST_TMP_DIR"
  export TIL_SKIP_PUSH=true
  export EDITOR="echo"

  source ./til
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  PATH="$DIR/..:$PATH"
}

teardown() {
  # Clean up temp directory
  rm -rf "$TEST_TMP_DIR"
}

@test "create_markdown_file creates file with correct title" {
  filepath=$(create_markdown_file "Test Title")

  # Check that the file exists and has proper title
  [ -f "$filepath" ]
  grep -q "# Test Title" "$filepath"
}

@test "create_markdown_file uses tags provided as parameter" {
  filepath=$(create_markdown_file "Test With Tags" "bash,testing")

  # Check that file contains the specified tags
  [ -f "$filepath" ]
  grep -q "tags: bash,testing" "$filepath"
}

@test "create_markdown_file uses TIL_TAGS when no tags provided" {
  export TIL_TAGS="default,tags"

  filepath=$(create_markdown_file "Test Default Tags")

  # Check that file contains the default tags
  [ -f "$filepath" ]
  grep -q "tags: default,tags" "$filepath"
}

@test "create_markdown_file prioritizes provided tags over TIL_TAGS" {
  export TIL_TAGS="default,tags"

  filepath=$(create_markdown_file "Test Override Tags" "override,tags")

  # Check that file contains the override tags
  [ -f "$filepath" ]
  grep -q "tags: override,tags" "$filepath"
}

@test "to_kebab_case converts title correctly" {
  result=$(to_kebab_case "This Is A Test Title")

  [ "$result" = "this-is-a-test-title" ]
}

@test "to_title_case keeps small words lowercase" {
  result=$(to_title_case "this is a test of the function")

  # "a", "of", "the" should be lowercase in title case
  [ "$result" = "This is a Test of the Function " ]
}

@test "generate_filepath creates correct path with date" {
  today=$(date +%Y-%m-%d)

  filepath=$(generate_filepath "Test Title")

  # Check filename format
  [ "$(basename "$filepath")" = "$today-test-title.md" ]
  # Check path
  [ "$(dirname "$filepath")" = "$TIL_FOLDER" ]
}

@test "main function with minimal arguments works" {
  run til "Test Main Function"

  [ "$status" -eq 0 ]
  [ -f "$output" ]
  grep -q "# Test Main Function" "$output"
}

@test "main function with tags argument works" {
  # Run main directly with tags
  filepath=$(main -t "test,tags" "Test Main With Tags")

  # Check tags are in file
  [ -f "$filepath" ]
  grep -q "tags: test,tags" "$filepath"
}

@test "main function with custom directory works" {
  custom_dir="$TEST_TMP_DIR/custom"
  mkdir -p "$custom_dir"

  # Run main with custom directory
  filepath=$(main -d "$custom_dir" "Custom Directory Test")

  # Check filepath
  [[ "$filepath" == "$custom_dir/"* ]]
  [ -f "$filepath" ]
}

@test "main function fails with error on missing title" {
  run main

  # Check that it exits with non-zero status
  [ "$status" -ne 0 ]

  # Check error message
  [[ "$output" == *"Error: Please provide a title"* ]]
}
