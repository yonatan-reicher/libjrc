#include <stdbool.h>

/// Does the first c-string begin with the second?
bool str_starts_with(const char *str, const char *prefix);
/// If the last character of a c-string is a newline, removes it.
void str_remove_newline(char *str);
