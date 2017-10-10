get_token()
{
	set +x
	read token < <(curl -d "grant_type=password&client_id=f20cd2d3-682a-4568-a53e-4262ef54c8f4&client_secret=AMenuDLjVdVo4BSwi0QD54LL6NeVDEZRzEQUJ7hJOM3g4imDZBHHX0hNfKHPeQIGkskhtCmqAJtt_jm7EKq-rWw&username=ega-test-data@ebi.ac.uk&password=egarocks&scope=openid" -H "Content-Type: application/x-www-form-urlencoded" -k https://ega.ebi.ac.uk:8443/ega-openid-connect-server/token | python -c "import sys, json; print json.load(sys.stdin)[\"access_token\"]")
	echo "obtained access token :"
	echo $token
	set -x
}


# do not exit on session disconnect
trap "" HUP  

#do not stop on errors
set +e 


if [[ "$@" == *fulltest ]]
then
    # remove last arg ( 'fulltest' )
    set -- "${@:1:$(($#-1))}"

    set +x
	echo ------------------------------------------
    echo TESTING BIG FILES.....might take hours....
    echo ------------------------------------------
    set -x

    get_token
	python tester.py -vv NA12878.bam https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/EGAF00001648197  "$@"
	get_token
	python tester.py -vv NA12878.cram https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/EGAF00001648209 "$@"

	get_token
	python tester.py -vv NA12891.bam https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/EGAF00001648195 "$@"
	get_token
	python tester.py -vv NA12891.cram https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/EGAF00001648207 "$@"

	get_token
	python tester.py -vv NA12892.bam https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/EGAF00001648193 "$@"
	get_token
	python tester.py -vv NA12892.cram https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/EGAF00001648205 "$@"
fi

set +x
echo ------------------------------------------------------------
echo Testing 2 small files ENCFF000VWO.bam and ENCFF284YOU.bam...
echo ------------------------------------------------------------
set -x

get_token
python tester.py -vv ENCFF000VWO.bam https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/ENCFF000VWO.bam "$@"
get_token
python tester.py -vv ENCFF284YOU.bam https://ega.ebi.ac.uk:8051/elixir/data/tickets/files/ENCFF284YOU.bam "$@"

set -e