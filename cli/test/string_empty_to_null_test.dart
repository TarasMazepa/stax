import "package:stax/string_empty_to_null.dart";
import "package:test/test.dart";

void main() {
  test("Test if empty string becomes null", () {
    String emptyString = "";
    expect(emptyString.emptyToNull(), null);
  });
}
