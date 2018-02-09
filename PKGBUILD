# Maintainer: Maxim Guryanov <taychi@inbox.ru>
pkgname=pinba-influxer
pkgrel=1
pkgver=20180208.10_0d97f8c
pkgdesc="Pinba-InfluxDB proxy-server"
arch=( 'x86_64' )
license=( 'GPL' )
makedepends=( 'go' 'git' )
backup=()
options=( '!strip' '!emptydirs' )
source=( "$pkgname::git://github.com/mguryanov/pinba-influxdb#branch=${BRANCH:-master}" )
md5sums=( 'SKIP' )

pkgver() {
 cd "$srcdir/$pkgname"
 local date=$(git log -1 --format="%cd" --date=short | sed s/-//g)
 local count=$(git rev-list --count HEAD)
 local commit=$(git rev-parse --short HEAD)
 echo "$date.${count}_$commit"
}

build() {
 cd ..

 export GOROOT=/usr/lib/go
 export GOPATH=$(pwd)/go
 export PATH=$GOPATH/bin:$PATH

 go get -v github.com/golang/dep/cmd/dep

 [[ -e $GOPATH/src/$pkgname ]] && rm -rf $GOPATH/src/$pkgname
 mv $srcdir/$pkgname $GOPATH/src

 cd "$GOPATH/src/$pkgname"
 rm -rf build
 mkdir -p build
 
 if [[ -e "Gopkg.toml" ]]; then
   dep ensure
 else 
   dep init
 fi

 GO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o build/$pkgname
}

package() {
 cd "$GOPATH/src/$pkgname"

 # Package default config (if available)
 pkgconfig='./deb/etc/pinba-influxer/config.yml.example'
 if [ -e $pkgconfig ]; then
   install -Dm644 $pkgconfig \
     "$pkgdir/etc/$pkgname/config.yml"
 fi

 # Package service script (if available)
 pkgservice='./deb/usr/lib/pinba-influxer/pinba-influxer.service'
 if [ -e $pkgservice ]; then
   install -Dm644 $pkgservice \
     "$pkgdir/usr/lib/systemd/system/$(basename $pkgservice)"
 fi

 # Package license (if available)
 pkglicense='LICENSE'
 if [ -e $pkglicense ]; then
   install -Dm644 $pkglicense \
     "$pkgdir/usr/share/licenses/$pkgname/$pkglicense"
 fi

 # Package executables
 if [ -e "build/$pkgname" ]; then
	install -Dm755 "build/$pkgname" \
        "$pkgdir/usr/bin/$pkgname"
 fi
}
