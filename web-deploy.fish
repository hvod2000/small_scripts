function web-deploy
	# ssh hvox.stream "sh -c 'cd /var/www/hvox.github.io && git pull origin'"
	set path (openssl rand -hex 32)
	scp -r (pwd) hvox.stream:/var/www/hvox.github.io/$path
	printf "%s\n" "https://hvox.art/$path/"
end
