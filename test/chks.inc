* Evaluate an expression and report observed result to expected
*   (rev by jac on 7/29/2023)
    setexit(.trapexception)
    &ERRLIMIT = 1000
    define('chks(expression,expected)')             :(chks.end)
chks

    errortype = ''
    expected = eval(expected)
    observed = eval(expression)                     :f(chks.oops)
chks.compare
    message = expression ' Obs[' observed '] Exp[' expected ']'
    observed pos(0) expected rpos(0)                :s(chks.pass)
    grade = '*FAIL: ' message errortype
    results = results char(10)  grade               :(return)
chks.pass
    grade = ' pass: ' message errortype
    results = results char(10) grade                :(return)
chks.oops
    errortype = ' (runtime)'
    observed = &errtext;                            :(chks.compare)
trapexception
    errortype = ' (exception)'
    observed = &errtext                             :(continue)
chks.end
