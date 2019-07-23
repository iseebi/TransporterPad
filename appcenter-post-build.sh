BUNDLE_IDENTIFIER=net.iseteki.TransporterPad
DISTRIBUTION_FILE=$APPCENTER_OUTPUT_DIRECTORY/TransporterPad_distribution.zip
xcrun altool --notarize-app --primary-bundle-id $BUNDLE_IDENTIFIER --username $AC_USERNAME --password $AC_PASSWORD --file $DISTRIBUTION_FILE
