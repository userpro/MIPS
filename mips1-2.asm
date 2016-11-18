# 字符串查找比较
# 
# 利用系统功能调用从键盘输入一个字符串，然后输入单个字符，# 查找该字符串中是否有该字符（区分大小写）。具体要求如下：
# 
# (1) 如果找到，则在屏幕上显示：
# 
# Success! Location: X
# 
# 其中，X为该字符在字符串中第一次出现的位置
# 
# (2) 如果没找到，则在屏幕上显示：
# 
# Fail!
# 
# (3) 输入一个字符串后，可以反复输入希望查询的字符，直到按# “?”键结束程序
# 
# (4) 每个输入字符独占一行，输出查找结果独占一行，位置编码# 从1开始。
# 
# 提示：为避免歧义，字符串内不包含"?"符号
# 
# 格式示例如下：
# 
# abcdefgh
# 
# a
# 
# Success! Location: 1
# 
# x
# 
# Fail!


.data
	success:	.asciiz	"\nSuccess!Location:"
	failed:		.asciiz "\nFail!\n"
	newline:	.asciiz	"\n"
	end:		.byte	'?'
	string:		.space	100
	in_char:	.byte
	
.text
main:
	la $a0,	string
	li $a1, 100
	li $v0, 8
	syscall
	
_loop:
	la $a0, in_char
	li $a1, 2
	li $v0, 8
	syscall
	
	j match
	j _loop

_done:
	li $v0, 10
	syscall
	
match:
	lb $t3, end
	lb $t4, in_char
	lb $t5, newline
	li $t0, 1
	la $t1, string
	beq $t3, $t4, _done

_match_loop:
	add $t1, $t1, $t0
	subi $t1, $t1, 1
	lb  $t2, ($t1)
	beq $t2, $t4, _match_ok
	beq $t2, $t5, _match_failed
	bge $t0, 100, _match_failed
	addi $t0, $t0, 1
	j _match_loop
	
_match_failed:
	la $a0, failed
	li $v0, 4
	syscall
	j _loop

_match_ok:
	la $a0, success
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	j _loop
