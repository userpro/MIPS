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

string_table: .asciiz
    _A: "Alpha\n",
    _a: "alpha\n",
    _B: "Bravo\n",
    _b: "bravo\n",
    _C: "China\n",
    _c: "china\n",
    _D: "Delta\n",
    _d: "delta\n",
    _E: "Echo\n",
    _e: "echo\n",
    _F: "Foxtrot\n",
    _f: "foxtrot\n",
    _G: "Golf\n",
    _g: "golf\n",
    _H: "Hotel\n",
    _h: "hotel\n",
    _I: "India\n",
    _i: "india\n",
    _J: "Juliet\n",
    _j: "juliet\n",
    _K: "Kilo\n",
    _k: "kilo\n",
    _L: "Lima\n",
    _l: "lima\n",
    _M: "Mary\n",
    _m: "mary\n",
    _N: "November\n",
    _n: "november\n",
    _O: "Oscar\n",
    _o: "oscar\n",
    _P: "Paper\n",
    _p: "paper\n",
    _Q: "Quebec\n",
    _q: "quebec\n",
    _R: "Research\n",
    _r: "research\n",
    _S: "Sierra\n",
    _s: "sierra\n",
    _T: "Tango\n",
    _t: "tango\n",
    _U: "Uniform\n",
    _u: "uniform\n",
    _V: "Victor\n",
    _v: "victor\n",
    _W: "Whisky\n",
    _w: "whisky\n",
    _X: "X-ray\n",
    _x: "x-ray\n",
    _Y: "Yankee\n",
    _y: "yankee\n",
    _Z: "Zulu\n",
    _z: "zulu\n",
    _1: "First\n",
    _2: "Second\n",
    _3: "Third\n",
    _4: "Fourth\n",
    _5: "Fifth\n",
    _6: "Sixth\n",
    _7: "Seventh\n",
    _8: "Eighth\n",
    _9: "Ninth\n",
    _0: "zero\n"

    table:  
        .word       _A,   _a,   _B,   _b,   _C,   _c,   _D,   _d,   _E,   _e,   _F,   _f,   _G,   _g,   _H,   _h,   _I,   _i,   _J,   _j,   _K,   _k,   _L,   _l,   _M,   _m,   _N,   _n,   _O,   _o,   _P,   _p,   _Q,   _q,   _R,   _r,   _S,   _s,   _T,   _t,   _U,   _u,   _V,   _v,   _W,   _w,   _X,   _x,   _Y,   _y,   _Z,   _z,   _1,   _2,   _3,   _4,   _5,   _6,   _7,   _8,   _9,   _0,   0
        
    
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
