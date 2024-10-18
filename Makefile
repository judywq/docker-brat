build:
	docker build --build-arg username=username --build-arg password=password123 --build-arg admin_email=example@gmail.com -t brat .

run:
	docker run --name brat_instance -p 80:80 -d brat

rm:
	docker stop brat_instance && docker rm brat_instance

# run troubleshooting script
ts:
	docker exec brat_instance /usr/local/apache2/htdocs/brat-1.3p1/tools/troubleshooting.sh http://localhost/brat-1.3p1
