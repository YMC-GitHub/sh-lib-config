<desc>
  read config passed with cli args
<desc/>
<args>
  -s,--sdate optional,passed arg with necessary value
  -e,--edate optional,passed arg with optional value
  -n,--numprocs optional,passed arg without value
  -h,--help optional,get the cmd help
<args/>
<how-to-run>
  run as shell args
    bash ./from-cli-args.sh
  run as runable application
    ./from-cli-args.sh --sdate=hi
<how-to-run/>
<demo-with-args>
  without-args
    ok:./from-cli-args.sh
  passed arg with necessary value
    ok:./from-cli-args.sh --sdate hi
    ok:./from-cli-args.sh --edate=hi
  passed arg with optional value
    ok:./from-cli-args.sh --edate=hello
    no:./from-cli-args.sh --edate hello
  passed arg without value
    ok:./from-cli-args.sh --numprocs
<demo-with-args/>
<how-to-get-help>
  ok:./from-cli-args.sh --help
  ok:./from-cli-args.sh -h
<how-to-get-help/>