* Evaluate an expression and report observed result to expected
*   (rev by jac on 9/27/2023) to fix bug in trapping exceptions
    define('chks(expression,expected)')                 :(chks.end)
chks
    setexit(.trapexception)
    &errlimit = 100
    observed = eval(expression)                         :f(chks.oops)
    message = expression ' Obs[' observed ']'
+                        ' Exp[' expected ']'
    diff = abs(observed - expected)
    le(diff,1.0e-12 * abs(expected))                    :s(chks.pass)f(chks.fail)
chks.oops
    observed = &errtext;
    message = expression ' Obs[' observed ']'
+                        ' Exp[' expected ']'
+                        ' (runtime error)'
    observed pos(0) expected rpos(0)                    :s(chks.pass)f(chks.fail)
trapexception
    observed = &errtext;
    setexit(.trapexception)
    message = expression ' Obs[' observed ']'
+                        ' Exp[' expected ']'
+                        ' (exception)'
    observed pos(0) expected rpos(0)                    :s(chks.pass)f(chks.fail)
chks.fail
    output = '*FAIL: ' message
    failcount = failcount + 1                            :(return)
chks.pass
    output = ' pass: ' message
    passcount = passcount + 1                           :(return)
chks.end

    define('abs(x)')                                    :(abs.end)
abs
    abs = x
    ge(x,0)                                             :s(return)
    abs = -x                                            :(return)
abs.end

    define('report()')                                  :(report.end)
report
    ne(failcount,'')                                    :s(report.passinit)
    failcount = 0;
report.passinit
    ne(passcount,'')                                    :s(report.totalinit)
    totalcount = 0;
report.totalinit
    totalcount = failcount + passcount
    output = '***********************************************************************************************'
    output = 'Total: ' totalcount '    Pass: ' passcount '    FAIL: ' failcount
    input
                                                        :(return)
report.end
