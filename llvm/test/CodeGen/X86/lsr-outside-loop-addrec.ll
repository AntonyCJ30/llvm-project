; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

; CHECK-NOT: addl $8192
; CHECK-NOT: addl $262144
; CHECK-NOT: addl $4194304
; CHECK-NOT: addl $1073741824

; CHECK: shll $13
; CHECK: shll $18
; CHECK: shll $22

; ModuleID = 'test.cpp'
source_filename = "test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@_ZL3src = internal global [100000000 x i8] zeroinitializer, align 16

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: read) uwtable
define dso_local noundef range(i32 0, -1073741823) i32 @_Z3runPcS_(ptr noundef readonly captures(address) %0, ptr noundef readnone captures(address) %1) local_unnamed_addr #0 {
  br label %3

3:                                                ; preds = %3, %2
  %4 = phi i64 [ 0, %2 ], [ %10, %3 ]
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 %4
  %6 = load i8, ptr %5, align 1, !tbaa !8
  %7 = icmp eq i8 %6, 0
  %8 = icmp ult ptr %5, %1
  %9 = and i1 %7, %8
  %10 = add i64 %4, 1
  br i1 %9, label %3, label %11, !llvm.loop !9

11:                                               ; preds = %3
  %12 = icmp ult i64 %4, 7
  br i1 %12, label %13, label %16

13:                                               ; preds = %11
  %14 = trunc nuw nsw i64 %4 to i32
  %15 = shl nuw nsw i32 %14, 13
  br label %28

16:                                               ; preds = %11
  %17 = icmp ult i64 %4, 15
  br i1 %17, label %18, label %21

18:                                               ; preds = %16
  %19 = trunc nuw nsw i64 %4 to i32
  %20 = shl nuw nsw i32 %19, 18
  br label %28

21:                                               ; preds = %16
  %22 = icmp ult i64 %4, 63
  %23 = trunc i64 %4 to i32
  br i1 %22, label %24, label %26

24:                                               ; preds = %21
  %25 = shl nuw nsw i32 %23, 22
  br label %28

26:                                               ; preds = %21
  %27 = shl i32 %23, 30
  br label %28

28:                                               ; preds = %26, %24, %18, %13
  %29 = phi i32 [ %15, %13 ], [ %20, %18 ], [ %25, %24 ], [ %27, %26 ]
  ret i32 %29
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem: none) uwtable
define dso_local noundef i32 @main() local_unnamed_addr #1 {
  br label %2

1:                                                ; preds = %2
  ret i32 %9

2:                                                ; preds = %0, %2
  %3 = phi i32 [ 0, %0 ], [ %10, %2 ]
  %4 = phi i32 [ 0, %0 ], [ %9, %2 ]
  %5 = and i32 %3, 7
  %6 = zext nneg i32 %5 to i64
  %7 = getelementptr inbounds nuw i8, ptr @_ZL3src, i64 %6
  %8 = tail call noundef i32 @_Z3runPcS_(ptr noundef nonnull %7, ptr noundef nonnull getelementptr inbounds nuw (i8, ptr @_ZL3src, i64 1024))
  %9 = add nsw i32 %8, %4
  %10 = add nuw nsw i32 %3, 1
  %11 = icmp eq i32 %10, 1000000
  br i1 %11, label %1, label %2, !llvm.loop !11
}

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: none, inaccessiblemem: none, target_mem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}
!llvm.errno.tbaa = !{!4}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"clang version 23.0.0git (git@github.com:AntonyCJ30/llvm-project.git 71d78b2220e4dc4b022fd74aec16ed8d93fc419e)"}
!4 = !{!5, !5, i64 0}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!6, !6, i64 0}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}
