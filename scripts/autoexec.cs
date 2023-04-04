$server::Hostname = "";

function autoexec::main() {
	%i = 1;

	while (%i < $cargc) {
		// each if block will clobber %i - this is by design.
		%currentFragment = $cargv[%i];
		
		// script
		if (%currentFragment == "-s") {
			// perform unique stuff here
			dbecho(3, "Initial script: " @ $cargv[%i + 1]);
		}
		
		// country
		if (%currentFragment == "-c") {
			%i = %i + 1;
			$server::Hostname = strcat($server::Hostname, $cargv[%i], ":");
			dbecho(3, "Setting Country to: " @ $cargv[%i]);
		}
		
		// hostname
		if (%currentFragment == "--") {
			while (%i < $cargc - 1) {
				%i = %i + 1;
				dbecho(3, "%i: " @ %i @ " $cargc " @ $cargc @ " $cargv[%i] " @ $cargv[%i]);
				if (!strlen($server::Hostname)) {
					$server::Hostname = strcat($server::Hostname, $cargv[%i]);
				}
				else {
					$server::Hostname = strcat($server::Hostname, " ", $cargv[%i]);
				}
			}

			dbecho(1, "Hostname set to '" @ $server::Hostname @ "'");
		}
		
		%i = %i + 1;
	}
}

autoexec::main();