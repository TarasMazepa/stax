import "package:stax/string_empty_to_null.dart";
import "package:test/test.dart";

void main() {
  test("empty string", () {
    expect("".emptyToNull(), null);
  });

  test("null", () {
    String? nullString;

    expect(nullString.emptyToNull(), null);
  });

  test("nonempty string", () {
    expect("something".emptyToNull(), "something");
  });
}
