# The package naming convention is <core_name>_xmdf
package provide delay_64_xmdf 1.0

# This includes some utilities that support common XMDF operations
package require utilities_xmdf

# Define a namespace for this package. The name of the name space
# is <core_name>_xmdf
namespace eval ::delay_64_xmdf {
# Use this to define any statics
}

# Function called by client to rebuild the params and port arrays
# Optional when the use context does not require the param or ports
# arrays to be available.
proc ::delay_64_xmdf::xmdfInit { instance } {
# Variable containing name of library into which module is compiled
# Recommendation: <module_name>
# Required
utilities_xmdf::xmdfSetData $instance Module Attributes Name delay_64
}
# ::delay_64_xmdf::xmdfInit

# Function called by client to fill in all the xmdf* data variables
# based on the current settings of the parameters
proc ::delay_64_xmdf::xmdfApplyParams { instance } {

set fcount 0
# Array containing libraries that are assumed to exist
# Examples include unisim and xilinxcorelib
# Optional
# In this example, we assume that the unisim library will
# be available to the simulation and synthesis tool
utilities_xmdf::xmdfSetData $instance FileSet $fcount type logical_library
utilities_xmdf::xmdfSetData $instance FileSet $fcount logical_library unisim
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64/doc/c_shift_ram_v11_0_readme.txt
utilities_xmdf::xmdfSetData $instance FileSet $fcount type Ignore
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64/doc/c_shift_ram_v11_0_vinfo.html
utilities_xmdf::xmdfSetData $instance FileSet $fcount type Ignore
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64/doc/ds228_shift_ram.pdf
utilities_xmdf::xmdfSetData $instance FileSet $fcount type Ignore
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64.asy
utilities_xmdf::xmdfSetData $instance FileSet $fcount type asy
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64.ngc
utilities_xmdf::xmdfSetData $instance FileSet $fcount type ngc
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64.sym
utilities_xmdf::xmdfSetData $instance FileSet $fcount type symbol
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64.veo
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog_template
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64.xco
utilities_xmdf::xmdfSetData $instance FileSet $fcount type coregen_ip
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path delay_64_xmdf.tcl
utilities_xmdf::xmdfSetData $instance FileSet $fcount type AnyView
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount associated_module delay_64
incr fcount

}

# ::gen_comp_name_xmdf::xmdfApplyParams
