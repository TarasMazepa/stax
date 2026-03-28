--- cli/lib/context/context.dart
+++ cli/lib/context/context.dart
@@ -43,84 +43,59 @@
     return ExternalCommand(parts, this);
   }

+  Context copyWith({
+    bool? quiet,
+    String? Function()? workingDirectory,
+    bool? verbose,
+    bool? acceptAll,
+    bool? declineAll,
+    bool? showPath,
+  }) {
+    return Context(
+      quiet ?? this.quiet,
+      workingDirectory != null ? workingDirectory() : this.workingDirectory,
+      verbose ?? this.verbose,
+      acceptAll ?? this.acceptAll,
+      declineAll ?? this.declineAll,
+      showPath ?? this.showPath,
+    );
+  }
+
   Context withQuiet(bool quiet) {
     if (this.quiet == quiet) return this;
-    return Context(
-      quiet,
-      workingDirectory,
-      verbose,
-      acceptAll,
-      declineAll,
-      showPath,
-    );
+    return copyWith(quiet: quiet);
   }

   Context quietly() => withQuiet(true);

   Context withVerbose(bool verbose) {
     if (this.verbose == verbose) return this;
-    return Context(
-      quiet,
-      workingDirectory,
-      verbose,
-      acceptAll,
-      declineAll,
-      showPath,
-    );
+    return copyWith(verbose: verbose);
   }

   Context withWorkingDirectory(String? workingDirectory) {
     if (this.workingDirectory == workingDirectory) return this;
-    return Context(
-      quiet,
-      workingDirectory,
-      verbose,
-      acceptAll,
-      declineAll,
-      showPath,
-    );
+    return copyWith(workingDirectory: () => workingDirectory);
   }

   Context withScriptPathAsWorkingDirectory() {
     return withWorkingDirectory(Platform.script.toFilePathDir());
   }

   Context withRepositoryRootAsWorkingDirectory() {
     return withWorkingDirectory(getRepositoryRoot());
   }

   Context withAcceptingAll(bool acceptAll) {
     if (this.acceptAll == acceptAll) return this;
-    return Context(
-      quiet,
-      workingDirectory,
-      verbose,
-      acceptAll,
-      declineAll,
-      showPath,
-    );
+    return copyWith(acceptAll: acceptAll);
   }

   Context withDecliningAll(bool declineAll) {
     if (this.declineAll == declineAll) return this;
-    return Context(
-      quiet,
-      workingDirectory,
-      verbose,
-      acceptAll,
-      declineAll,
-      showPath,
-    );
+    return copyWith(declineAll: declineAll);
   }

   Context withShowPath(bool showPath) {
     if (this.showPath == showPath) return this;
-    return Context(
-      quiet,
-      workingDirectory,
-      verbose,
-      acceptAll,
-      declineAll,
-      showPath,
-    );
+    return copyWith(showPath: showPath);
   }

   bool shouldBeQuiet() {
