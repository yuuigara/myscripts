#!/bin/sh

# refs: http://d.hatena.ne.jp/uasi/20110323/1300892559

#
# Create Google Chrome launcher (for Mac)
#

CHROME_APP="/Applications/Google Chrome.app"
CHROME_PROFILE_DIR="$HOME/Library/Application Support/Google/Chrome"

echo "Enter profile name: \c"
read PROFILE_NAME
if [ "x$PROFILE_NAME" == "x" ]; then
	echo "Error: profile name is empty"
	exit
fi

echo "Enter launcher name [Google Chrome ($PROFILE_NAME)]: \c"
read LAUNCHER_NAME
if [ "x$LAUNCHER_NAME" == "x" ]; then
	LAUNCHER_NAME="Google Chrome ($PROFILE_NAME)"
fi

echo "Enter boot options []: \c"
read OPTIONS

echo "Enter dist dir [.]: \c"
read DIST_DIR
if [ "x$DIST_DIR" == "x" ]; then
	DIST_DIR="."
fi

USER_DATA_DIR="$CHROME_PROFILE_DIR/$PROFILE_NAME"
CONTENTS_DIR="$DIST_DIR/$LAUNCHER_NAME.app/Contents"

if [ ! -e "$CHROME_APP" ]; then
	echo "Google Chrome is not installed"
	exit
fi

if [ -e "$USER_DATA_DIR" ]; then
	echo "Profile exists"
else
	echo "Create profile at $USER_DATA_DIR"
	mkdir -p "$USER_DATA_DIR"
fi

if [ -e "$CONTENTS_DIR" ]; then
	echo "Launcher exists"
	exit
fi

echo "Create launcher at $DIST_DIR/$LAUNCHER_NAME.app"
mkdir -p "$CONTENTS_DIR"
mkdir "$CONTENTS_DIR/MacOS"
mkdir "$CONTENTS_DIR/Resources"

echo "Copy resources from Google Chrome"
cp "$CHROME_APP/Contents/Resources/app.icns" "$CONTENTS_DIR/Resources"

echo "Write Info.plist"
cat <<EOD > "$CONTENTS_DIR/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIconFile</key>
	<string>app.icns</string>
</dict>
</plist>
EOD

echo "Write executable"
cat << EOD > "$CONTENTS_DIR/MacOS/$LAUNCHER_NAME"
#!/bin/sh

"$CHROME_APP/Contents/MacOS/Google Chrome" $OPTIONS --user-data-dir="$USER_DATA_DIR" &
EOD
chmod +x "$CONTENTS_DIR/MacOS/$LAUNCHER_NAME"

echo "Done"
