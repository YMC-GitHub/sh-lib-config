<desc>
  genarate basic docs file
<desc/>
<args>
  --project-path optional,set the project path
  --file-list optional,set the file name of list write
  -d,--debug optional,set the debug mode
  -h,--help optional,get the cmd help
<args/>
<how-to-run>
  run as shell args
    bash ./write-docs.sh
  run as runable application
    ./write-docs.sh --project-path eth0
<how-to-run/>
<demo-with-args>
  without-args
    ok:./write-docs.sh
  passed arg with necessary value
    ok:./write-docs.sh --project-path eth0
    ok:./write-docs.sh --project-path=eth0
  passed arg with optional value
  passed arg without value
  basic-usage:
    set the file name (tpl list file)
      with relative path ,it relative to the project path
        ok:./write-docs.sh --file-list ./src/docs.list
      with absolute path
        ok:./write-docs.sh --file-list /d/docs.list
    set the project path
      with relative path ,it relative to the project path
        ok:./write-docs.sh --project-path ../hell-get-config
      with absolute path
        ok:./write-docs.sh --project-path /d/code-store/Shell/shell-get-config
<demo-with-args/>
<how-to-get-help>
  ok:./write-docs.sh --help
  ok:./write-docs.sh -h
  ok:./write-docs.sh --debug
<how-to-get-help/>