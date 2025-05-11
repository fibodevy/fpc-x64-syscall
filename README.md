# fpc-x64-syscall

```pas
// NtOpenProcess
syscall($26, [@h, pointer(PROCESS_TERMINATE), @obj, @cid]);

// NtTerminateProcess
syscall($2c, [pointer(h)]);
```

#### Syscalls table
https://github.com/j00ru/windows-syscalls/blob/master/x64/csv/nt.csv
