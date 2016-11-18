# 第一题：用系统功能调用实现简单输入输出
# 
# 利用系统功能调用从键盘输入，转换后在屏幕上显示，具体要求如下：
# 
# (1) 如果输入的是字母（A~Z，区分大小写）或数字（0~9），则将其转换成对应的英文单词后在屏幕上显示，对应关系见下表
# 
# (2) 若输入的不是字母或数字，则在屏幕上输出字符“*”，
# 
# (3) 每输入一个字符，即时转换并在屏幕上显示，
# 
# (4) 支持反复输入，直到按“?”键结束程序。

# A  Alpha   N   November    1   First   a   alpha   n   november
# B   Bravo   O   Oscar   2   Second  b   bravo   o   oscar
# C   China   P   Paper   3   Third   c   china   p   paper
# D   Delta   Q   Quebec  4   Fourth  d   delta   q   quebec
# E   Echo    R   Research    5   Fifth   e   echo    r   research
# F   Foxtrot S   Sierra  6   Sixth   f   foxtrot s   sierra
# G   Golf    T   Tango   7   Seventh g   golf    t   tango
# H   Hotel   U   Uniform 8   Eighth  h   hotel   u   uniform
# I   India   V   Victor  9   Ninth   i   india   v   victor
# J   Juliet  W   Whisky  0   zero    j   juliet  w   whisky
# K   Kilo    X   X-ray           k   kilo    x   x-ray
# L   Lima    Y   Yankee          l   lima    y   yankee
# M   Mary    Z   Zulu            m   mary    z   zulu

.data 
    length: .word   62
    inputs: .space  4
    string: .asciiz "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890"
    end:    .asciiz "?"
    failed: .asciiz "*\n"

    _A: .asciiz "Alpha\n"
    _a: .asciiz "alpha\n"
    _B: .asciiz "Bravo\n"
    _b: .asciiz "bravo\n"
    _C: .asciiz "China\n"
    _c: .asciiz "china\n"
    _D: .asciiz "Delta\n"
    _d: .asciiz "delta\n"
    _E: .asciiz "Echo\n"
    _e: .asciiz "echo\n"
    _F: .asciiz "Foxtrot\n"
    _f: .asciiz "foxtrot\n"
    _G: .asciiz "Golf\n"
    _g: .asciiz "golf\n"
    _H: .asciiz "Hotel\n"
    _h: .asciiz "hotel\n"
    _I: .asciiz "India\n"
    _i: .asciiz "india\n"
    _J: .asciiz "Juliet\n"
    _j: .asciiz "juliet\n"
    _K: .asciiz "Kilo\n"
    _k: .asciiz "kilo\n"
    _L: .asciiz "Lima\n"
    _l: .asciiz "lima\n"
    _M: .asciiz "Mary\n"
    _m: .asciiz "mary\n"
    _N: .asciiz "November\n"
    _n: .asciiz "november\n"
    _O: .asciiz "Oscar\n"
    _o: .asciiz "oscar\n"
    _P: .asciiz "Paper\n"
    _p: .asciiz "paper\n"
    _Q: .asciiz "Quebec\n"
    _q: .asciiz "quebec\n"
    _R: .asciiz "Research\n"
    _r: .asciiz "research\n"
    _S: .asciiz "Sierra\n"
    _s: .asciiz "sierra\n"
    _T: .asciiz "Tango\n"
    _t: .asciiz "tango\n"
    _U: .asciiz "Uniform\n"
    _u: .asciiz "uniform\n"
    _V: .asciiz "Victor\n"
    _v: .asciiz "victor\n"
    _W: .asciiz "Whisky\n"
    _w: .asciiz "whisky\n"
    _X: .asciiz "X-ray\n"
    _x: .asciiz "x-ray\n"
    _Y: .asciiz "Yankee\n"
    _y: .asciiz "yankee\n"
    _Z: .asciiz "Zulu\n"
    _z: .asciiz "zulu\n"
    _1: .asciiz "First\n"
    _2: .asciiz "Second\n"
    _3: .asciiz "Third\n"
    _4: .asciiz "Fourth\n"
    _5: .asciiz "Fifth\n"
    _6: .asciiz "Sixth\n"
    _7: .asciiz "Seventh\n"
    _8: .asciiz "Eighth\n"
    _9: .asciiz "Ninth\n"
    _0: .asciiz "zero\n"

    table:  
        .word   _A
        .word   _a
        .word   _B
        .word   _b
        .word   _C
        .word   _c
        .word   _D
        .word   _d
        .word   _E
        .word   _e
        .word   _F
        .word   _f
        .word   _G
        .word   _g
        .word   _H
        .word   _h
        .word   _I
        .word   _i
        .word   _J
        .word   _j
        .word   _K
        .word   _k
        .word   _L
        .word   _l
        .word   _M
        .word   _m
        .word   _N
        .word   _n
        .word   _O
        .word   _o
        .word   _P
        .word   _p
        .word   _Q
        .word   _q
        .word   _R
        .word   _r
        .word   _S
        .word   _s
        .word   _T
        .word   _t
        .word   _U
        .word   _u
        .word   _V
        .word   _v
        .word   _W
        .word   _w
        .word   _X
        .word   _x
        .word   _Y
        .word   _y
        .word   _Z
        .word   _z
        .word   _1
        .word   _2
        .word   _3
        .word   _4
        .word   _5
        .word   _6
        .word   _7
        .word   _8
        .word   _9
        .word   _0
        .word   0
        
    
.text 
main:
    # $t0:end    $t1:str arr index  $t2:input char              $t3:length     
    # $t4:(Temp) step               $t5:address of string[1]    $t6:string[i]
    # $s0:string    $s1:the char of string
    lb   $t0, end
    la   $s0, string
    
_main_loop:
    li   $a1, 2
    la   $a0, inputs
    li   $v0, 8  # read
    syscall

    jal  compare
    
    li   $v0, 4  # print
    syscall
    
    bne  $t0, $t2, _main_loop
  
    li   $v0, 10 # exit
    syscall


compare:
    li   $t1, 0
    lb   $t2, ($a0)
    lw   $t3, length
    li   $t4, 1  # step
    la   $s0, string # init
_cmp_loop:
    lb   $s1, ($s0)
    beq  $t2, $s1, match_ok
    addu $t1, $t1, 1
    addu $s0, $s0, $t4
    bge  $t1, $t3, match_failed
    j    _cmp_loop
_cmp_end:
    jr   $ra
    
match_ok:
    la   $t5, table
    mul  $t4, $t1, 4   # 4 * byte
    addu $t5, $t5, $t4 # address of string[i]
    lw   $t6, 0($t5)   # string[i]
    move $a0, $t6
    j    _cmp_end
    
match_failed:
    la   $a0, failed
    j    _cmp_end
