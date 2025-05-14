program syscall;

uses JwaWindows;

{$asmmode intel}
function _syscall(syscallid: uint64): uint64; assembler; nostackframe;
asm
  mov r10, rcx
  mov rax, [rsp + 40]
  add rsp, 16
  syscall
  sub rsp, 16
  ret
end;

function syscall(syscallid: uint64; args: array of pointer): ntstatus;
type
  tsyscall = function(a1, a2, a3, a4: pointer; syscallid, dummy: uint64; a5, a6, a7, a8, a9: pointer): uint64; cdecl;
var
  a: array[0..8] of pointer;
  i: integer;
begin
  for i := 0 to high(args) do a[i] := args[i];
  for i := high(args)+1 to high(a) do a[i] := nil;
  result := tsyscall(@_syscall)(a[0], a[1], a[2], a[3], syscallid, 0, a[4], a[5], a[6], a[7], a[8]);
end;

var
  obj: OBJECT_ATTRIBUTES;
  cid: CLIENT_ID;
  h: handle;
  ret: ntstatus;

begin
  obj.Length := sizeof(obj);
  cid.UniqueProcess := 52680; // PID

  // NtOpenProcess
  ret := syscall($26, [@h, pointer(PROCESS_TERMINATE), @obj, @cid]);
  writeln('ret = ', ret, ' | h = ', h);

  // NtTerminateProcess
  ret := syscall($2c, [pointer(h)]);
  writeln('ret = ', ret);

  readln;
end.

