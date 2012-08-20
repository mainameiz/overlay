# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI=4

inherit rpm

DESCRIPTION="Brother HL-2132 printer support files"
HOMEPAGE=""
RESTRICT="nomirror"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/cupswrapperHL2132-2.0.4-2.i386.rpm
    http://www.brother.com/pub/bsc/linux/dlf/hl2132lpr-2.1.0-1.i386.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/rpm
	app-text/psutils"

RDEPEND="app-text/psutils
	net-print/cups"

S="${WORKDIR}"

BRPRINTER_NAME="HL2132"
PRINTCAP_NAME="/etc/cups/printers.conf"
SPOOLER_NAME="/var/spool/lpd/$BRPRINTER_NAME"
DEVICE_IF="/dev/usb/lp0"
ppd_file_name="/usr/share/ppd/${BRPRINTER_NAME}.ppd"
brotherlpdwrapper="/usr/libexec/cups/filter/brlpdwrapper${BRPRINTER_NAME}"

src_install() {
	cp -R ${S}/* ${D}/

	###################
	###    Driver   ###
	###################

	dodir "${SPOOLER_NAME}"
	fowners "lp:lp" "${SPOOLER_NAME}"
	fperms "0700" "${SPOOLER_NAME}"
	
	mkdir -p "${D}/etc/cups"
    cat <<EOF >> "${D}/${PRINTCAP_NAME}"
${BRPRINTER_NAME}:\\
    :mx=0:\\
    :sd=/var/spool/lpd/${BRPRINTER_NAME}:\\
    :sh:\\
    :lp=${DEVICE_IF}:\\
    :if=/usr/local/Brother/Printer/${BRPRINTER_NAME}/lpd/filter${BRPRINTER_NAME}:
EOF


	#"${D}/usr/local/Brother/Printer/${BRPRINTER_NAME}/inf/braddprinter" -i "${BRPRINTER_NAME}"

	PSTOPS=`which pstops 2>/dev/null`
	if [ "`echo $PSTOPS | grep -i cups`" != "" ];then
		PSTOPS=""
	fi
	if [ "$PSTOPS" != "" ];then
		echo [psconvert2]   >> "${D}/usr/local/Brother/Printer/${BRPRINTER_NAME}/inf/br${BRPRINTER_NAME}func"
		echo pstops=$PSTOPS >> "${D}/usr/local/Brother/Printer/${BRPRINTER_NAME}/inf/br${BRPRINTER_NAME}func"
	fi

	####################
	### CUPS Wrapper ###
	####################

	mkdir -p "${D}/usr/share/ppd"
	cat <<ENDOFPPDFILE > "${D}/${ppd_file_name}"
*PPD-Adobe: "4.3"
*%================================================
*%	Copyright Brother Industries,Ltd 2006-2008
*%	"Brother HL2132 for CUPS"
*%================================================

*%==== General Information Keywords ========================
*FormatVersion: "4.3"
*FileVersion: "1.00"
*LanguageEncoding: ISOLatin1
*LanguageVersion: English
*Manufacturer: "Brother"
*PCFileName: "HL2132.PPD"
*Product: "(Brother HL2132 series)"
*cupsVersion:   1.1
*cupsManualCopies: True
*cupsModelNumber:       72
*cupsFilter: "application/vnd.cups-postscript 0 brlpdwrapperHL2132"
*PSVersion: "(3010.106) 3"
*ModelName: "HL2132"
*NickName: "Brother HL2132 for CUPS"
*ShortNickName: "Brother HL2132 for CUPS"

*%==== Basic Device Capabilities =============
*LanguageLevel: "3"
*TTRasterizer: Type42
*ColorDevice: False
*DefaultColorSpace: Gray
*FileSystem: True
*?FileSystem:"
save 
	/devname (%disk0%) def 
	/ret false def 
	0 1 7{ 
		devname exch 48 add 5 exch put 
		devname devstatus { 
			0 ne {/ret true def}if 
			pop pop pop pop pop pop pop 
		}if 
	}for 
	ret {(True)}{(False)} ifelse = flush 
restore 
" 
*End

*Throughput: "18"
*FreeVM: "1700000"



*%==== Media Selection ======================

*OpenUI *PageSize: PickOne
*OrderDependency: 30 AnySetup *PageSize
*DefaultPageSize: A4
*PageSize Letter/Letter: "                      "
*PageSize Legal/Legal: "                      "
*PageSize Executive/Executive: "                      "
*PageSize A4/A4: "                      "
*PageSize A5/A5: "                      "
*PageSize A6/A6: "                      "
*PageSize Env10/Com-10: "                      "
*PageSize EnvMonarch/Monarch: "                      "
*PageSize EnvDL/DL: "                      "
*PageSize EnvC5/C5: "                      "
*PageSize EnvISOB5/B5: "                      "
*PageSize EnvISOB6/B6: "                      "
*CloseUI: *PageSize

*OpenUI *PageRegion: PickOne
*OrderDependency: 40 AnySetup *PageRegion
*DefaultPageRegion: A4
*PageRegion Letter/Letter: "                      "
*PageRegion Legal/Legal: "                      "
*PageRegion Executive/Executive: "                      "
*PageRegion A4/A4: "                      "
*PageRegion A5/A5: "                      "
*PageRegion A6/A6: "                      "
*PageRegion Env10/Com-10: "                      "
*PageRegion EnvMonarch/Monarch: "                      "
*PageRegion EnvDL/DL: "                      "
*PageRegion EnvC5/C5: "                      "
*PageRegion EnvISOB5/B5: "                      "
*PageRegion EnvISOB6/B6: "                      "
*CloseUI: *PageRegion

*DefaultImageableArea: A4
*ImageableArea Letter/Letter: "18 12 594 780"
*ImageableArea Legal/Legal: "18 12 594 996"
*ImageableArea Executive/Executive: "18 12 504 744"
*ImageableArea A4/A4: "18 12 577 830"
*ImageableArea A5/A5: "18 12 403 583"
*ImageableArea A6/A6: "18 12 279 408"
*ImageableArea Env10/Com-10: "18 12 279 672"
*ImageableArea EnvMonarch/Monarch: "18 12 261 528"
*ImageableArea EnvDL/DL: "18 12 294 612"
*ImageableArea EnvC5/C5: "18 12 441 637"
*ImageableArea EnvISOB5/B5: "18 12 463 697"
*ImageableArea EnvISOB6/B6: "18 12 336 487"

*%==== Information About Media Sizes ========

*DefaultPaperDimension: A4
*PaperDimension Letter/Letter: "612 792"
*PaperDimension Legal/Legal: "612 1008"
*PaperDimension Executive/Executive: "522 756"
*PaperDimension A4/A4: "595 842"
*PaperDimension A5/A5: "420 595"
*PaperDimension A6/A6: "297 420"
*PaperDimension Env10/Com-10: "297 684"
*PaperDimension EnvMonarch/Monarch: "279 540"
*PaperDimension EnvDL/DL: "312 624"
*PaperDimension EnvC5/C5: "459 649"
*PaperDimension EnvISOB5/B5: "499 709"
*PaperDimension EnvISOB6/B6: "354 499"

*%==== 5.13 Media Handling Features ============================
*OpenUI *BrMediaType/BrMediaType: PickOne
*OrderDependency: 28 AnySetup *BrMediaType
*DefaultBrMediaType: PLAIN
*BrMediaType PLAIN/Plain Paper: "                      "
*BrMediaType THIN/Thin Paper: "                      "
*BrMediaType THICK/Thick Paper: "                      "
*BrMediaType THICKERPAPER2/Thicker Paper: "                      "
*BrMediaType BOND/Bond Paper: "                      "
*BrMediaType TRANSPARENCIES/Transparencies: "                      "
*BrMediaType ENV/Envelopes: "                      "
*BrMediaType ENVTHICK/Env. Thick: "                      "
*BrMediaType ENVTHIN/Env. Thin: "                      "
*CloseUI: *BrMediaType

*OpenUI *InputSlot/InputSlot: PickOne
*OrderDependency: 29 AnySetup *InputSlot
*DefaultInputSlot: TRAY1
*InputSlot MANUAL/Manual Feed: "                      "
*InputSlot TRAY1/Tray1: "                      "
*CloseUI: *InputSlot

*RequiresPageRegion All:True


*%=== Output Bin =============================
*% === Collate ==========
*%==== 5.14 Finishing Features =================================
*%%%%% Resolution and Appearance Control %%%%%
*OpenUI *Resolution: PickOne
*OrderDependency: 11 AnySetup *Resolution
*DefaultResolution: 600dpi
*Resolution	600dpi: "                      "
*Resolution	2400x600dpi/HQ1200dpi: "                    "
*CloseUI: *Resolution

*OpenUI *TonerSaveMode/Toner Save: PickOne
*DefaultTonerSaveMode: OFF
*OrderDependency: 10 AnySetup  *TonerSaveMode
*TonerSaveMode OFF/Off: "statusdict begin false tonersave end"
*TonerSaveMode ON/On: "statusdict begin true tonersave end"
*CloseUI: *TonerSaveMode

*OpenUI *Sleep/Sleep Time [Min.]: PickOne
*DefaultSleep: PrinterDefault
*OrderDependency: 10 AnySetup  *Sleep
*Sleep PrinterDefault/Printer Default: ""
*Sleep 2minutes/2: "statusdict begin 2 powersavetime end"
*Sleep 10minutes/10: "statusdict begin 10 powersavetime end"
*Sleep 30minutes/30: "statusdict begin 30 powersavetime end"
*CloseUI: *Sleep

*%==== 5.20 Font Related Keywords ==============================
*DefaultFont: Courier
*Font AvantGarde-Book: Standard "(001.006S)" Standard ROM
*Font AvantGarde-BookOblique: Standard "(001.006S)" Standard ROM
*Font AvantGarde-Demi: Standard "(001.007S)" Standard ROM
*Font AvantGarde-DemiOblique: Standard "(001.007S)" Standard ROM
*Font Bookman-Demi: Standard "(001.004S)" Standard ROM
*Font Bookman-DemiItalic: Standard "(001.004S)" Standard ROM
*Font Bookman-Light: Standard "(001.004S)" Standard ROM
*Font Bookman-LightItalic: Standard "(001.004S)" Standard ROM
*Font Courier: Standard "(002.004S)" Standard ROM
*Font Courier-Bold: Standard "(002.004S)" Standard ROM
*Font Courier-BoldOblique: Standard "(002.004S)" Standard ROM
*Font Courier-Oblique: Standard "(002.004S)" Standard ROM
*Font Helvetica: Standard "(001.006S)" Standard ROM
*Font Helvetica-Bold: Standard "(001.007S)" Standard ROM
*Font Helvetica-BoldOblique: Standard "(001.007S)" Standard ROM
*Font Helvetica-Narrow: Standard "(001.006S)" Standard ROM
*Font Helvetica-Narrow-Bold: Standard "(001.007S)" Standard ROM
*Font Helvetica-Narrow-BoldOblique: Standard "(001.007S)" Standard ROM
*Font Helvetica-Narrow-Oblique: Standard "(001.006S)" Standard ROM
*Font Helvetica-Oblique: Standard "(001.006S)" Standard ROM
*Font NewCenturySchlbk-Bold: Standard "(001.009S)" Standard ROM
*Font NewCenturySchlbk-BoldItalic: Standard "(001.007S)" Standard ROM
*Font NewCenturySchlbk-Italic: Standard "(001.006S)" Standard ROM
*Font NewCenturySchlbk-Roman: Standard "(001.007S)" Standard ROM
*Font Palatino-Bold: Standard "(001.005S)" Standard ROM
*Font Palatino-BoldItalic: Standard "(001.005S)" Standard ROM
*Font Palatino-Italic: Standard "(001.005S)" Standard ROM
*Font Palatino-Roman: Standard "(001.005S)" Standard ROM
*Font Times-Bold: Standard "(001.007S)" Standard ROM
*Font Times-BoldItalic: Standard "(001.009S)" Standard ROM
*Font Times-Italic: Standard "(001.007S)" Standard ROM
*Font Times-Roman: Standard "(001.007S)" Standard ROM
*Font ZapfChancery-MediumItalic: Standard "(001.007S)" Standard ROM
*Font ZapfDingbats: Special "(001.004S)" Special ROM
*Font Symbol: Special "(001.007S)" Special ROM
*Font Alaska: Standard "(001.005)" Standard ROM
*Font AlaskaExtrabold: Standard "(001.005)" Standard ROM
*Font AntiqueOakland: Standard "(001.005)" Standard ROM
*Font AntiqueOakland-Bold: Standard "(001.005)" Standard ROM
*Font AntiqueOakland-Oblique: Standard "(001.005)" Standard ROM
*Font ClevelandCondensed: Standard "(001.005)" Standard ROM
*Font Connecticut: Standard "(001.005)" Standard ROM
*Font Guatemala-Antique: Standard "(001.005)" Standard ROM
*Font Guatemala-Bold: Standard "(001.005)" Standard ROM
*Font Guatemala-Italic: Standard "(001.005)" Standard ROM
*Font Guatemala-BoldItalic: Standard "(001.005)" Standard ROM
*Font LetterGothic: Standard "(001.005)" Standard ROM
*Font LetterGothic-Bold: Standard "(001.005)" Standard ROM
*Font LetterGothic-Oblique: Standard "(001.005)" Standard ROM
*Font Maryland: Standard "(001.005)" Standard ROM
*Font Oklahoma: Standard "(001.005)" Standard ROM
*Font Oklahoma-Bold: Standard "(001.005)" Standard ROM
*Font Oklahoma-Oblique: Standard "(001.005)" Standard ROM
*Font Oklahoma-BoldOblique: Standard "(001.005)" Standard ROM
*Font Utah: Standard "(001.005)" Standard ROM
*Font Utah-Bold: Standard "(001.005)" Standard ROM
*Font Utah-Oblique: Standard "(001.005)" Standard ROM
*Font Utah-BoldOblique: Standard "(001.005)" Standard ROM
*Font UtahCondensed: Standard "(001.005)" Standard ROM
*Font UtahCondensed-Bold: Standard "(001.005)" Standard ROM
*Font UtahCondensed-Oblique: Standard "(001.004)" Standard ROM
*Font UtahCondensed-BoldOblique: Standard "(001.005)" Standard ROM
*Font BermudaScript: Standard "(001.005)" Standard ROM
*Font Germany: Standard "(001.005)" Standard ROM
*Font SanDiego: Standard "(001.005)" Standard ROM
*Font US-Roman: Standard "(001.005)" Standard ROM
*?FontQuery: "
save
count 1 gt
  {exch dup dup
   =string cvs (/) print print (:) print
   FontDirectory exch known
     {pop(Yes)}
     {(fonts/)AppendName exch pop mark exch
      {}=string filenameforall counttomark
      0 gt
        {cleartomark(Yes)}
        {cleartomark(No)}ifelse
     }ifelse
   =
  }if
  (*) = flush
restore
"
*End
*?FontList: "
save
  FontDirectory{pop ==}forall
  (fonts/*)
  {dup length 6 sub 6 exch getinterval cvn ==
  }=string filenameforall
  (*) = flush
restore
"
*End

ENDOFPPDFILE

	fperms "0755" "${ppd_file_name}"

	mkdir -p "${D}/usr/libexec/cups/filter"
	cat <<!ENDOFWFILTER! > "${D}/${brotherlpdwrapper}"
#! /bin/sh
#
# Brother Print filter  >>  $brotherlpdwrapper
# Copyright (C) 2005 Brother. Industries, Ltd.
#                                    Ver1.00

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA
#
LOGFILE="/dev/null"
LOGCLEVEL="7"
DEBUG=0
NUPENABLE=1
ENABLECOPY=0
LOG_LATESTONLY=1
errorcode=0

set +o noclobber
if [ "\`echo \$5 | grep 'debug-noprint=1'\`" != '' ]; then
    DEBUG=1
fi
if [ "\`echo \$5 | grep 'debug-noprint=2'\`" != '' ]; then
    DEBUG=2
fi
if [ "\`echo \$5 | grep 'debug-noprint=3'\`" != '' ]; then
    DEBUG=3
fi
if [ \$DEBUG != 0 ]; then
    LOGFILE=/tmp/br_cupsfilter_debug_log
fi

PRINTER=HL2132


if [ "\$PPD" = "" ]; then
    PPD="/usr/share/ppd/${BRPRINTER_NAME}.ppd"
fi


if [ \$LOGFILE != "/dev/null" ]; then
  if [ \$LOG_LATESTONLY == "1" ]; then
    rm -f \$LOGFILE
    date                                                           >\$LOGFILE
  else
    if [ -e \$LOGFILE ]; then
	    date                                                        >>\$LOGFILE
    else
	    date                                                        >\$LOGFILE
    fi
  fi
    echo "arg0 = \$0"                                           >>\$LOGFILE
    echo "arg1 = \$1"                                           >>\$LOGFILE
    echo "arg2 = \$2"                                           >>\$LOGFILE
    echo "arg3 = \$3"                                           >>\$LOGFILE
    echo "arg4 = \$4"                                           >>\$LOGFILE
    echo "arg5 = \$5"                                           >>\$LOGFILE
    echo "arg6 = \$6"                                           >>\$LOGFILE
    echo "PPD  = \$PPD"                                         >>\$LOGFILE
fi

INPUT_TEMP_PS=\`mktemp /tmp/br_input_ps.XXXXXX\`

nup="cat"
if [ "\`echo \$5 | grep 'Nup='\`" != '' ] && [ \$NUPENABLE != 0 ]; then

	if   [ "\`echo \$5 | grep 'Nup=64'\`" != '' ]; then
		nup="psnup -64"
	elif [ "\`echo \$5 | grep 'Nup=32'\`" != '' ]; then
		nup="psnup -32"
	elif [ "\`echo \$5 | grep 'Nup=25'\`" != '' ]; then
		nup="psnup -25"
	elif [ "\`echo \$5 | grep 'Nup=16'\`" != '' ]; then
		nup="psnup -16"
	elif [ "\`echo \$5 | grep 'Nup=8'\`" != '' ]; then
		nup="psnup -8"
	elif [ "\`echo \$5 | grep 'Nup=6'\`" != '' ]; then
		nup="psnup -6"
	elif [ "\`echo \$5 | grep 'Nup=4'\`" != '' ]; then
		nup="psnup -4"
	elif [ "\`echo \$5 | grep 'Nup=2'\`" != '' ]; then
		nup="psnup -2"
	elif [ "\`echo \$5 | grep 'Nup=1'\`" != '' ]; then
		nup="cat"
	fi
	echo   "NUP=\$nup"                                      >>\$LOGFILE
   if [ -e /usr/bin/psnup ]; then
       if [ \$# -ge 7 ]; then
	       cat \$6  | \$nup > \$INPUT_TEMP_PS
       else
	       cat       | \$nup > \$INPUT_TEMP_PS
       fi
   else
       if [ \$# -ge 7 ]; then
	       cp \$6  \$INPUT_TEMP_PS
       else
	       cat    > \$INPUT_TEMP_PS
       fi
   fi
else
   if [ \$# -ge 7 ]; then
      cp \$6  \$INPUT_TEMP_PS
   else
      cat    > \$INPUT_TEMP_PS
   fi
fi

if [ "\$ENABLECOPY" != 0 ];then
  if [ "\$4" -ge 2 ];then
     options="\$5"" ""Copies=\$4"
  else
     options="\$5"
  fi
else
  options="\$5"
fi


if [ -e "/usr/local/Brother/Printer/\$PRINTER/lpd/filter\$PRINTER" ]; then
       :
else
    echo "ERROR: /usr/local/Brother/Printer/\$PRINTER/lpd/filter\$PRINTER does not exist"   >>\$LOGFILE
    errorcode=30
    exit $errorcode
fi

if [ -e "/usr/local/Brother/Printer/HL2132/cupswrapper/brcupsconfig4" ]; then
  if [ \$DEBUG = 0 ]; then
     /usr/local/Brother/Printer/HL2132/cupswrapper/brcupsconfig4  \$PRINTER  \$PPD 0 "\$options" >> /dev/null
  else
     /usr/local/Brother/Printer/HL2132/cupswrapper/brcupsconfig4  \$PRINTER  \$PPD \$LOGCLEVEL "\$options" >>\$LOGFILE
  fi
fi


if [ \$DEBUG -le 2 ]; then
    cat    \$INPUT_TEMP_PS | /usr/local/Brother/Printer/\$PRINTER/lpd/filter\$PRINTER
fi

if [ \$DEBUG -ge 2 ];  then
	   if [ \$LOGFILE != "/dev/null" ]; then
	     echo ""                                                >>\$LOGFILE
	     echo "    ------PostScript Data-------"                >>\$LOGFILE
	     cat    \$INPUT_TEMP_PS                                  >>\$LOGFILE
	   fi
fi
rm -f  \$INPUT_TEMP_PS

exit \$errorcode

!ENDOFWFILTER!

	fperms "0755" "${brotherlpdwrapper}"

	fperms "a+w" "usr/local/Brother/Printer/${BRPRINTER_NAME}/inf/br${BRPRINTER_NAME}rc"
	fperms "a+w" "usr/local/Brother/Printer/${BRPRINTER_NAME}/inf"
}

pkg_postinst() {
	port2=`lpinfo -v | grep -i "usb://Brother/${BRPRINTER_NAME}" | head -1`
	if [ "$port2" = '' ];then
	  port2=`lpinfo -v | grep -i 'usb://Brother/' | head -1`
	  if [ "$port2" = '' ];then
		   port2=`lpinfo -v | grep 'usb://' | head -1`
	  fi
	fi
	
	port=`echo $port2 | sed s/direct\ //g`
	
	if [ "$port" = '' ];then
		port=usb:/dev/usb/lp0
	fi

	lpadmin -p "${BRPRINTER_NAME}" -E -v "$port" -P "${ppd_file_name}"
}

pkg_prerm() {
	# wrapper part
	lpadmin -x "${BRPRINTER_NAME}"

	# driver part
	set +o noclobber
	cp "$PRINTCAP_NAME" "$PRINTCAP_NAME.tmp"
	cat "${PRINTCAP_NAME}.tmp" | eval sed "/${BRPRINTER_NAME}:/,/filter${BRPRINTER_NAME}:/d" > "${PRINTCAP_NAME}"
	rm -f "${PRINTCAP_NAME}.tmp"

	#"/usr/local/Brother/Printer/${BRPRINTER_NAME}/inf/braddprinter" -e "${BRPRINTER_NAME}"
}
