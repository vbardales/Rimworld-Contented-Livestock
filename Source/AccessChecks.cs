// Krafs.Publicizer publicises the reference assembly, which is what lets Patch_Production write
// __instance.fullness and __instance.eggProgress at all. In the real Assembly-CSharp those two
// fields are protected and private: the compiler emits a plain cross-assembly ldfld either way,
// and the CLR allows that instruction only when this assembly declares the waiver below.
//
// Publicizer defines the attribute type for us and normally applies it through the SDK's
// generated AssemblyInfo — which this project switches off with GenerateAssemblyInfo=false. The
// type was therefore embedded and the waiver was not. Nothing said so: the build stayed clean,
// the patches applied, and every milkable animal threw FieldAccessException on its first tick
// with the whole scaling half of the mod dead behind it.
//
// _tools/Run-Functional-Tests.ps1 catches this by performing the access rather than by reading
// metadata, which is how it was found without launching the game.

[assembly: System.Runtime.CompilerServices.IgnoresAccessChecksTo("Assembly-CSharp")]
