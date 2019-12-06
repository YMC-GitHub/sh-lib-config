<desc>
  write help file for sh file
<desc/>
<args>
  --project-path optional,set the project path
  --file-list optional,set the tpl list file name
  -d,--debug optional,set the debug mode
  -h,--help optional,get the cmd help
<args/>
<how-to-run>
  run as shell args
    bash ./write-helps.sh
  run as runable application
    ./write-helps.sh --project-path eth0
<how-to-run/>
<demo-with-args>
  without-args
    ok:./write-helps.sh 
  passed arg with necessary value
    ok:./write-helps.sh --project-path eth0
    ok:./write-helps.sh --project-path=eth0
  passed arg with optional value
  passed arg without value
  basic-usage:
    set the file name (tpl list file)
      with relative path ,it relative to the project path
        ok:./write-helps.sh --file-list ./src/help.tpl.list
      with absolute path
        ok:./write-helps.sh --file-list /d/help.tpl.list
    set the project dir
      with relative path ,it relative to the project path
        ok:./write-helps.sh path ../hell-get-config
      with absolute path
        ok:./write-helps.sh path /d/code-store/Shell/shell-get-config
<demo-with-args/>
<how-to-get-help>
  ok:./write-helps.sh --help
  ok:./write-helps.sh -h
  ok:./write-helps.sh --debug
<how-to-get-help/>