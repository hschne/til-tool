#!/usr/bin/env bat
#!/usr/bin/env bats

# Source the til script to access its functions directly
setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  export TEST_TMP_DIR="$(mktemp -d)"
  export TIL_FOLDER="$TEST_TMP_DIR"
  export TIL_SKIP_PUSH=true
  export EDITOR="true"

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

  assert [ -f "$filepath" ]
  run grep "# Test Title" "$filepath"
  assert_success
}

@test "create_markdown_file uses tags provided as parameter" {
  filepath=$(create_markdown_file "Test With Tags" "bash,testing")

  assert [ -f "$filepath" ]
  run grep "tags: bash,testing" "$filepath"
  assert_success
}

@test "create_markdown_file uses TIL_TAGS when no tags provided" {
  export TIL_TAGS="default,tags"

  filepath=$(create_markdown_file "Test Default Tags")

  assert [ -f "$filepath" ]
  run grep "tags: default,tags" "$filepath"
  assert_success
}

@test "create_markdown_file prioritizes provided tags over TIL_TAGS" {
  export TIL_TAGS="default,tags"

  filepath=$(create_markdown_file "Test Override Tags" "override,tags")

  assert [ -f "$filepath" ]
  run grep "tags: override,tags" "$filepath"
  assert_success
}

@test "to_kebab_case converts title correctly" {
  result=$(to_kebab_case "This Is A Test Title")

  assert_equal "$result" "this-is-a-test-title"
}

@test "to_title_case keeps small words lowercase" {
  result=$(to_title_case "this is a test of the function")

  # "a", "of", "the" should be lowercase in title case
  assert_equal "$result" "This is a Test of the Function "
}

@test "generate_filepath creates correct path with date" {
  today=$(date +%Y-%m-%d)

  filepath=$(generate_filepath "Test Title")

  # Check filename format
  assert_equal "$(basename "$filepath")" "$today-test-title.md"
  # Check path
  assert_equal "$(dirname "$filepath")" "$TIL_FOLDER"
}

@test "main function with minimal arguments works" {
  filepath=$(main "Test Main")

  assert [ -f "$filepath" ]
  run grep "# Test Main" "$filepath"
  assert_success
}

@test "main function with tags argument works" {
  # Run main directly with tags
  filepath=$(main -t "test,tags" "Test Main With Tags")

  assert [ -f "$filepath" ]
  run grep "tags: test,tags" "$filepath"
  assert_success
}

@test "main function with custom directory works" {
  custom_dir="$TEST_TMP_DIR/custom"
  mkdir -p "$custom_dir"

  # Run main with custom directory
  filepath=$(main -d "$custom_dir" "Custom Directory Test")

  assert [ "$filepath" == "$custom_dir/"* ]
  assert [ -f "$filepath" ]
}

@test "main function fails with error on missing title" {
  run main

  assert_failure
  assert_output --partial "Error: Please provide a title"
}
