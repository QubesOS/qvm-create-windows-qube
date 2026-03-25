<div align="center">
    <a href="https://github.com/ElliotKillick/qvm-create-windows-qube">
        <img width="160" src="logo.png" alt="Logo" />
    </a>
</div>

<h3 align="center">
    Qvm-Create-Windows-Qube
</h3>

<p align="center">
    Spin up new Windows qubes quickly, effortlessly and securely
</p>

<div align="center">
    <img src="https://img.shields.io/travis/com/ElliotKillick/qvm-create-windows-qube?style=flat-square" alt="Travis CI build" />
    <a href="LICENSE">
        <img src="https://img.shields.io/github/license/ElliotKillick/qvm-create-windows-qube?style=flat-square" alt="License" />
    </a>
    <a href="https://www.qubes-os.org">
        <img src="https://img.shields.io/badge/Made%20for-Qubes%20OS-63a0ff?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAACE0lEQVR4Ae2Vg5JdQRiE56HyQrGTQmzbTgqxbdu2bWvN09vLf3E1OlfTVV/pYvobqpCQHMyqMziy%2bizKCVr4rfIlLPuXIBGrzuKjytWw3Dspm5J6fvduLm2XG42lCDSp4m8PZbP4XpaoJLDkTzb2%2bU8Cl3BbvYljn7%2bQQb1Qx5W96mO7XOCf1xLERIXL7VJmM6NGB1z4YVsehpQk%2bK9qAhOUSZadMhqsltvtbIoz9JDfiQgyYQ1ZReYe1ZSYsBt3Ju8F5h0BVpzOaLCIAz3VWNkvmQgsPgGM2Q303QD0XIc7OgJoZep%2bYOExgDObbKDvhhfD5kTnaw1ZfgqYzHEHbAJ6rGP5FjQFhIlkxgFgyQnXN4XccCyOlZykmYeBoVulNLEVECbtAeZwAJ6Pn8px5h9D1fAdQO/1MuuOBQTlKVI8TwV6FoNAEAgCQSAIBIEgEATINw/lr8YjIJQ5LH%2bdIF4B4bhF8YsEGXJbR%2bC0pkREtqsM02sdjmsU15t9kcA9Ak2q0xTfzjKRFNObff8Swt8E26WawL68vsRlAhNG70RN7/Wo0y4t/FDWEZFbBgKggEnxSPkIS%2b0hUQwCF5WfyC3lVUD47VvkmlcB4aVPifWkzpuAUOd7NQ5mKFBHHhi%2bB79JN98i55MJ8CG70ult%2bOfzSrV%2bP0QgwWEUiZOkJkXxCrJT5XpY8iGRR49S5KrK8YQ0AG5m/ZMNiwL6AAAAAElFTkSuQmCC&style=flat-square" alt="Made for Qubes OS" />
    </a>
</div>

## About

Qvm-Create-Windows-Qube is a tool for quickly and conveniently installing fresh new Windows [qubes](https://www.qubes-os.org/doc/glossary/#qube) with [Qubes Windows Tools (QWT)](https://www.qubes-os.org/doc/windows-tools/) drivers automatically. It officially supports Windows 7, 8.1 and 10 as well as Windows Server 2008 R2, 2012 R2, 2016 and 2019.

The project emphasizes correctness, security and treating Windows as an untrusted guest operating system throughout the entire process. The installation takes place 100% air gapped and features optional [Whonix integration](https://github.com/ElliotKillick/qvm-create-windows-qube#whonix-recommendations-for-windows-whonix-workstation) on the finished Windows qube for added privacy. Accomplishing these goals in as few lines of code as possible to ensure simplicity and minimalism is key.

It also features other niceties such as automatic installation of packages including Firefox, Office 365, Notepad++, Visual Studio and more using Chocolatey to get you up and running quickly in your new environment.

**As featured on: [<img width="15" src="https://news.ycombinator.com/favicon.ico" alt="Hacker News Favicon" /> Hacker News](https://news.ycombinator.com/item?id=28900125)** | *Proudly ranked in the top 10 on the front page of Hacker News as well as first place for Show HN*

## Installation

1. Download the [installation script](https://raw.githubusercontent.com/ElliotKillick/qvm-create-windows-qube/master/install.sh) by opening the link, right-clicking and then selecting "Save [Page] as..."
2. Copy `install.sh` into Dom0 by running the following command in Dom0:
    - `qvm-run -p --filter-escape-chars --no-color-output <name_of_qube_script_is_located_on> "cat '/home/user/Downloads/install.sh'" > install.sh`
    - Make sure to get all the single and double quotes
3. Review the code of `install.sh` to ensure its integrity
    - Safer with escape character filtering enabled in the previous step; `qvm-run` disables it by default when the output is a file
4. Run `chmod +x install.sh && ./install.sh`
    - Note that this will install packages in the global default `TemplateVM`, which is `fedora-XX` by default
5. Review the code of the resulting `/usr/bin/qvm-create-windows-qube`

### Updating

To update Qvm-Create-Windows-Qube, start by simply deleting the `windows-mgmt` VM and main program by running the following command in Dom0:

`qvm-remove -f windows-mgmt && sudo rm /usr/bin/qvm-create-windows-qube`

Lastly, follow the installation steps above to reinstall.

Note that this will also delete any Windows ISOs that have already been downloaded. This may be desirable in the case that Microsoft has updated the Windows ISOs (meaning you should redownload them anyway). However, if you would like to avoid downloading any of the Windows ISOs again, simply navigate to `/home/user/qvm-create-windows-qube/windows/isos` in the `windows-mgmt` VM and copy its contents to another (preferably disposable) qube. After the reinstall is complete, copy those ISOs back into `windows-mgmt` at the aforementioned directory.

## Usage

```
Usage: qvm-create-windows-qube [options] -i <iso> -a <answer file> <name>
  -h, --help
  -c, --count <number> Number of Windows qubes with given basename desired
  -t, --template Make this qube a TemplateVM instead of a StandaloneVM
  -n, --netvm <qube> NetVM for Windows to use
  -s, --seamless Enable seamless mode persistently across reboots
  -o, --optimize Optimize Windows by disabling unnecessary functionality for a qube
  -y, --spyless Configure Windows telemetry settings to respect privacy
  -w, --whonix Apply Whonix recommended settings for a Windows-Whonix-Workstation
  -p, --packages <packages> Comma-separated list of packages to pre-install (see available packages at: https://chocolatey.org/packages)
  -P, --pool <name> LVM storage pool to install Windows on (https://www.qubes-os.org/doc/secondary-storage/)
  -i, --iso <file> Windows media to automatically install and setup
  -a, --answer-file <xml file> Settings for Windows installation
  -d, --disk-size <size> Specify system disk size, in GiB; default: 30
  --mem <size> Specify initial memory, in MiB; default: 2048
  --vcpu <number> Specify number of virtual CPUs; default: 2
  --priv <size> Specify private disk size, in GiB; default: 10
```

### Downloading Windows ISO

Mido (`mido.sh`) is the secure Microsoft Windows Downloader (for Unix), inspired by [Fido](https://github.com/pbatard/Fido) from [Rufus](https://github.com/pbatard/rufus). It's capable of automating the download process for a few Windows ISOs that Microsoft has behind a [gated download web interface](https://www.microsoft.com/en-us/software-download/windows10ISO). Mido is robust and securely downloads Windows ISOs to be used by Qvm-Create-Windows-Qube from official Microsoft servers. You can find it located at `/home/user/qvm-create-windows-qube/windows/isos/mido.sh` in `windows-mgmt`.

`windows-mgmt` is air gapped from the network. This means that in order to securely perform the download, one must copy the `mido.sh` script to another (disposable) qube followed by transferring the newly downloaded ISO(s) into `windows-mgmt` and placing them into the `/home/user/qvm-create-windows-qube/windows/isos` directory. Alternatively, `windows-mgmt` can temporarily be given network access, however, this isn't recommended for security reasons.

Once generated, Windows ISOs are cached in `/home/user/qvm-create-windows-qube/windows/out` for later use. If you download an updated ISO with Mido, then make sure to remove the same ISO from the aforementioned cache directory. This will cause the cache to be regenerated from the updated ISO.

For advanced readers: Qvm-Create-Windows-Qube takes a generic approach to handling ISOs that can work with any given Windows ISO. If you have your own Windows ISO you would like to use then likely only a very slight adjustment to the closest matching answer file (namely the `/IMAGE/NAME` key) would be needed to make it work. You can get the valid `/IMAGE/NAME` values for your ISO by parsing the `install.wim` inside using the `wiminfo` command (packaged as `wimlib-utils` on Fedora or `wimtools` on Debian) or from within Windows using Windows ADK.

### Creating Windows VM

**Important:** Be sure to read the [Qubes Windows Tools Known Issues](https://github.com/ElliotKillick/qvm-create-windows-qube#qubes-windows-tools-known-issues) section below for a small upstream issue.

#### Windows 10

*[Video demonstration](https://www.youtube.com/watch?v=cCi2MOUwS_Q)*

`qvm-create-windows-qube -n sys-firewall -oyp firefox,notepadplusplus,office365proplus -i win10x64.iso -a win10x64-pro.xml work-win10`

`qvm-create-windows-qube -n sys-firewall -oyp steam -i win10x64.iso -a win10x64-pro.xml game-console`

#### Windows Server 2019

`qvm-create-windows-qube -n sys-firewall -oy -i win2019-eval.iso -a win2019-datacenter-eval.xml fs-win2019`

#### Windows 10 Enterprise LTSC

- A more stable, minified, secure and private version of Windows 10 officially provided by Microsoft
- This version of Windows 10 is recommended for those who need the best in Windows security and privacy

`qvm-create-windows-qube -n sys-firewall -oyp firefox,notepadplusplus,office365proplus -i win10x64-enterprise-ltsc-eval.iso -a win10x64-enterprise-ltsc-eval.xml work-win10`

`qvm-create-windows-qube -n sys-whonix -oyw -i win10x64-enterprise-ltsc-eval.iso -a win10x64-enterprise-ltsc-eval.xml anon-win10`

#### Windows 7

- Not recommended because Windows 7 is [no longer supported](https://github.com/ElliotKillick/qvm-create-windows-qube#advisories) by Microsoft, however, it's the only desktop OS the Qubes GUI driver (in Qubes Windows Tools) supports if seamless window integration or dynamic resizing is required

*[Video demonstration](https://www.youtube.com/watch?v=duUM1VLrXIQ)*

`qvm-create-windows-qube -n sys-firewall -soyp firefox,notepadplusplus,office365proplus -i win7x64-ultimate.iso -a win7x64-ultimate.xml work-win7`

## Security

Qvm-Create-Windows-Qube is "reasonably secure" as [Qubes](https://www.qubes-os.org) would have it.

- `windows-mgmt` is air gapped
- The entirety of the Windows qube setup process is done air gapped
    - Exception: If (and only if) packages are configured for installation then Windows will be allowed access to the Internet at the very end of the Windows qube installation
- Entire class of command injection vulnerabilities eliminated in the Dom0 shell script by not letting it parse any output from the untrusted `windows-mgmt` qube
    - Only exit codes are passed by `qvm-run`; no variables
    - This also mitigates the fallout of another [Shellshock](https://en.wikipedia.org/wiki/Shellshock_(software_bug)) Bash vulnerability
- Downloading of the Windows ISOs is made secure by enforcing:
    - ISOs are downloaded straight from Microsoft controlled subdomains of `microsoft.com`
    - HTTPS TLS 1.2/1.3
    - SHA-256 verification of the files after download
        - Each file is saved with the extension `.UNVERIFIED` until it's made certain that its checksum is a match
    - Mido is robustly written in POSIX sh (the minimal Dash shell will be used if available) so interaction with Microsoft's gated download web interface is more secure
        - For more security, it could even be run in a POSIX-compliant Rust shell (e.g. nsh) with Rust coreutils (e.g. uutils). This is not the default configuration.
- Windows is treated as an untrusted guest operating system the entire way through
- The impact of any theoretical vulnerabilities in handling of the Windows ISO (e.g. vulnerability in filesystem parsing) or answer file is limited to `windows-mgmt`
- All commits by the maintainers are always signed with their respective PGP keys
    - Should signing ever cease, assume compromise
    - Current maintainer 1: [Elliot Killick](https://github.com/ElliotKillick)
        - PGP key ([code signing subkey](https://keys.openpgp.org/search?q=EEEE+6403+CE85+0791+ECB1+F820+7C4E+CB25+B6B1+C0DE)): EEEE 6403 CE85 0791 ECB1 F820 7C4E CB25 B6B1 C0DE
        - Email: [contact@elliotkillick.com](https://keys.openpgp.org/search?q=contact%40elliotkillick.com)
        - This key is new starting May 28th, 2024
    - Current maintainer 2: [Frédéric Pierret](https://github.com/fepitre)
        - PGP key: 9FA6 4B92 F95E 706B F28E 2CA6 4840 10B5 CDC5 76E2
        - Email: [frederic.pierret@qubes-os.org](https://keys.openpgp.org/search?q=frederic.pierret%40qubes-os.org)
        - Mostly concerned with Qubes R4.1 support
            - See the `release4.1` branch and [qubes-mgmt-salt-windows-mgmt](https://github.com/fepitre/qubes-mgmt-salt-windows-mgmt)

### Windows

#### Maintenance

Don't forget to apply any applicable updates upon creation of your Windows qube. Microsoft frequently builds up-to-date ISOs for current versions of Windows, such as Windows 10. For these Windows versions, it's recommended to periodically download the latest version using Mido to get a fresh Windows image out of the box.

#### Advisories

Windows 7 and Windows Server 2008 R2 reached end of life (EOL) on [January 14, 2020](https://support.microsoft.com/en-us/help/4057281/windows-7-support-will-end-on-january-14-2020).

## Privacy

Qvm-Create-Windows-Qube aims to be the most private way to use Windows. Many Qubes users switched from Windows (or another proprietary OS) in part to get away from Microsoft (or Big Tech in general) and so being able to use Windows from a safe distance is of utmost importance to this project. Or at least, as safe a distance as possible for what is essentially a huge, proprietary binary blob.

### Windows Telemetry

Configures Windows telemetry settings to respect privacy.

- Opt-out of Customer Experience Improvement Program (CEIP)
- Disable Windows Error Reporting (WER)
- Disable DiagTrack service
- Switch off all telemetry in Windows 10 "Settings" application
- Enable ["Security"](https://docs.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization#diagnostic-data-settings) level of telemetry on compatible editions of Windows 10
- See `spyless.bat` for more info

### Whonix Recommendations for Windows-Whonix-Workstation

Everything mentioned [here](https://www.whonix.org/wiki/Other_Operating_Systems) up to "Even more security" is implemented. "Most security" is to use an official Whonix-Workstation built yourself from source. This feature is not official or endorsed by Whonix.

It's recommended to read [this](https://www.whonix.org/wiki/Windows_Hosts) Whonix documentation to understand the implications of using Windows in this way.

### Easy to Reset Fingerprint

There are countless unique identifiers present in every Windows installation such as the MachineGUID, installation ID, NTFS drive Volume Serial Numbers (VSNs) and more. With Qvm-Create-Windows-Qube, these unique identifiers can easily be reset by automatically reinstalling Windows.

### Limitations

Fingerprinting is possible through the hypervisor in the event of VM compromise, here are some practical examples (not specific to Windows):

- [Xen clocksource as wallclock](https://phabricator.whonix.org/T389)
    - Timezone leak can at least be mitigated by configuring UTC time in the BIOS/UEFI
        - The local timezone can still be configured for the XFCE Dom0 clock and in desired VMs by running `timedatectl set-timezone` every boot using the standard `/rw/config/rc.local` Qubes provides
    - However, time correlation between VMs remains trivial
- [CPUID](https://github.com/QubesOS/qubes-issues/issues/1142)
- Generally, some of the VM interfaces documented [here](https://www.qubes-os.org/doc/vm-interface/) (e.g. screen dimensions)

## Frequently Asked Questions (FAQ)

### Do I need a Windows license to use this project?

No, with every Windows installation comes an embedded trial product key which is used by default if none other is provided. Qvm-Create-Windows-Qube explicitly specifies no product key in the answer files in order to use the default trial key.

On general consumer versions of Windows such as (non-enterprise) 7, 8.1 and 10, these trials extend forever with the understanding that a watermark or pop up may start appearing requesting activation of the product.

On Windows Enterprise Evaluation and Server Evaluation versions, once the trial is up the machine will automatically (and without warning) be shut down after being up for a set amount of time by the Windows License Monitoring Service (`C:\Windows\System32\wlms\wlms.exe`; it's in a hidden folder). When this occurs, the aforementioned reason for shutdown will be logged in the Event Viewer. To renew the trial run `slmgr /rearm` in the command prompt. This will work for the number of times specified in `slmgr /dlv` (it can vary) at which point the product must be activated or reinstalled.

It's recommended that you license the product when the trial is up in all cases.

Giving Windows Internet access is not required for using the trial key (as it's embedded within each ISO). However, it is required for activating Windows with a product key of your own (unless you do activation by phone).

### What is the purpose of the `windows-mgmt` AppVM? May I delete it once the Windows installation is complete?

The purpose of the `windows-mgmt` AppVM is to securely isolate everything that goes on as part of the Windows installation to a single virtual machine. That way, the exploitation of any bugs that exist in, for example, in the Linux ISO filesystem parsing code is limited in the amount of harm it can do should a Windows ISO be malicious. This is the security principle upon which all of Qubes OS is built upon, it's known as "security by isolation" or "security by compartmentalization".

Feel free to delete `windows-mgmt` if you are sure there are no more Windows VMs you would like to create. However, if it's just the disk space you want to reclaim then you can simply delete the ISOs located at `/home/user/qvm-create-windows-qube/windows/isos` and `/home/user/qvm-create-windows-qube/windows/out` (in `windows-mgmt`) to save the vast majority of that space.

### Anything else I should know?

Don't enable "Include in memory balancing" (the checkbox) in the Windows qube settings. This feature of Qubes OS is currently unstable on Windows and enabling it will lead to frequent Windows crashes (BSODs).

## Contributing

You can start by giving this project a star! High quality PRs are also welcome! Take a look at the todo list below if you're looking for things that need improvement. Other improvements such as more elegant ways of completing a task, code cleanup and other fixes are also welcome.

Lots of Windows-related [GSoCs](https://www.qubes-os.org/gsoc/) for those interested.

The logo of this project is by Max Andersen, used with written permission.

This project is the product of an independent effort that is not officially endorsed by Qubes OS.

## Qubes Windows Tools Known Issues

- The new QWT installer disables private disk creation by default
    - This is probably due to stability concerns?
    - Can't make a TemplateVM

### Newer Xen Drivers Notice (for olders OSs such as Windows 7)

In Qubes R4.1, Qubes Windows Tools comes with newer drivers that work better on newer versions of Windows such as Windows 10. Unfortunately, it's also been documented that these new drivers work less well with older versions of Windows such as Windows 7. Ideally, the fixes should be consolidated into a single driver but that is yet to happen.

Windows 7 is an EOL operating system at this point so this is less important. However, there are still some valid reasons for using (at least an air gapped) Windows 7 machine (e.g. for technical research/testing purposes).

There are community members documenting this experience (I can also attest to it) on the Qubes OS Forum and a few Qubes OS GitHub issues.

#### Mailing list threads

- [qubes-users](https://groups.google.com/forum/#!topic/qubes-users/AdQcjg7XOFo)
- [qubes-devel](https://groups.google.com/forum/#!topic/qubes-devel/aCCGpYysZTQ)

#### Windows tagged Qubes OS GitHub issues

- [`C: windows-tools`](https://github.com/QubesOS/qubes-issues/labels/C%3A%20windows-tools)
- [`C: windows-vm`](https://github.com/QubesOS/qubes-issues/labels/C%3A%20windows-vm)

## Todo

- [x] Gain the ability to reliably unpack/insert answer file/repack for any given ISO file containing a UDF filesystem ([ISO 13346](https://en.wikipedia.org/wiki/Universal_Disk_Format), i.e. the Windows ISO format)
    - ISO file containers are essentially write-once filesystems; you cannot just add a file to it without creating a whole new ISO
    - Opening an official Microsoft Windows ISO file in a hex editor shows clear evidence of it containing a UDF filesystem and specifically mentions `ISO-13346` at the top
    - Note that the `file` command may slightly misidentify these ISO files as being the now supplanted ISO 9660 format but that's probably only because "UDF shares the basic volume descriptor format with ISO 9660"
    - This is the same way VMWare does it as can be seen by the "Creating Disk..." part in the video below (Further research indicates that they use `mkisofs`)
    - [ ] In the future, it would be best for Qubes to do this by [extending core admin for libvirt XML templates](https://github.com/QubesOS/qubes-issues/issues/5085)
        - Faster
        - Saves storage due to not having to create a new ISO
- [x] auto-qwt takes D:\\ making QWT put the user profile on E:\\; it would be nicer to have it on D:\\ so there is no awkward gap in the middle
- [x] Make Windows answer file automatically use default trial key for Windows installation without hard-coding any product keys anywhere (Windows is finicky on this one)
- [x] Support Windows 8.1-10 (Note: QWT doesn't fully officially any OS other than Windows 7 yet, however, everything is functional except the GUI driver)
- [x] Support Windows Server 2008 R2 to Windows Server 2019
- [x] Support Windows 10 Enterprise LTSC (Long Term Support Channel)
    - Provides security updates for 10 years, very stable and less bloat than stock Windows 10
- [ ] Support Windows 11
    - Qvm-Create-Windows-Qube was made to be Windows version independent, the only real work to do here is creating an answer file (probably just slightly modifying the Windows 10 one) and adding it `mido.sh` (which will not be a problem now that I've extended it's functionality to download from behind the gated Microsoft ISO download API)
    - The real question is whether Qubes Windows Tools is going to work under Windows 11
        - Microsoft has a fantastic track record for backwards compatibility even at the kernel API level though (because businesses love backwards compatibility) so it's possible it works just fine
        - Help wanted, testers welcome
- [x] Provision Chocolatey
- [x] Add an option to slim down Windows as documented for Qubes [here](https://www.qubes-os.org/doc/windows-template-customization/)
- [x] Make `windows-mgmt` air gapped
- [x] Extend functionality of `download-windows.sh` (now `mido.sh` to download ISOs from behind Microsoft's gated ISO download API
- [ ] I recently discovered this is a Qubes [Google Summer of Code](https://www.qubes-os.org/gsoc/) project
    - [x] Add automated tests
        - Using Travis CI for automated ShellCheck
    - [x] ACPI tables for fetching Windows the license embedded there
        - Found more info on this, should be very simple by just placing the following jinja libvirt template extension in `/etc/qubes/templates/libvirt/xen/by-name/<windows_qube>`
            - Thanks to @jevank for the [patch](https://github.com/QubesOS/qubes-issues/issues/5279#issuecomment-525947408)
    - [ ] Port to Python
        - This seems like it would be unnecessary for scripts like `create-media.sh` where the Python script would essentially just be calling out to external programs
        - This would certainly be suitable for the `qvm-create-windows-qube` program though
            - This would allow us to interchange data between Dom0 and the VM without worrying about the potential for command injection or another Shellshock
- [ ] Automatically select which answer file to use based on Windows ISO characteristics gathered from the `wiminfo` command (Currently a WIP; see branch)
    - `wiminfo` works just like DISM on Windows
    - [ ] Once core admin is extended to allow for libvirt XML templates (answer files) becomes possible (previous todo, it's a blocking issue), we could also securely read the characteristics of the install.wim from the ISO without even having to mount the ISO as a loop device using [`libguestfs`](https://libguestfs.org)
        - I've also seen `libguestfs` used on QEMU/KVM so it's definitely a good candidate for this use case
        - Note that `libguestfs` cannot write (an answer file) to an ISO which is why we there's no point in using using this library until we no longer need to create a whole new ISO to add the answer file to it
- [x] Follow [Whonix documentation](https://www.whonix.org/wiki/Other_Operating_Systems) to make Windows-Whonix-Workstation
- [ ] Add functionality for `create-media.sh` to add MSUs (Microsoft Update standalone packages) to be installed during the Windows PE pass (specifically "Installing updates...") of Windows setup
    - We could fix currently not working QWT installation for old Windows 7 SP1 and Windows Server 2008 (non-R2) ISOs using [KB4474419](https://github.com/QubesOS/qubes-issues/issues/3585#issuecomment-521280301) to add SHA-256 driver signing support
        - The other option is to have Xen sign their drivers with SHA-1 as well, which other driver vendors seem to do, but is not ideal from a security standpoint
    - Allows us to get rid of `allow-drivers.vbs` hack by fixing SHA-256 *automatic* driver installation bug in newer versions of Windows 7 with KB2921916 (see `allow-drivers.vbs` for details)
        - This Windows bug was intentionally patched and unpatched by Microsoft in an attempt to force enterprises to upgrade to Windows 10
    - Patch a couple Windows security bugs?
        - Patch BlueKeep for Windows 7 out of the box
        - Windows Server 2008 R2 base ISO is also vulnerable to ETERNALBLUE and BlueKeep out of the box
        - Probably not worth getting into that, users should just update the VM upon making it
- [ ] Headless mode
    - Help wanted
        - What mechanism is there to accomplish this in Qubes? Something in Qubes GUI agent/daemon?
- [ ] Package this project so its delivery can be made more streamlined and secure through `qubes-dom0-update`
- [ ] Add [ReactOS](https://reactos.org) support as an open source alternative to Windows
    - This would be a good at least until a [ReactOS template is made](https://github.com/QubesOS/qubes-issues/issues/2809)
    - Perhaps ReactOS developers may want to use this to develop ReactOS
    - Or maybe just add ReactOS as a template (outside of this project)
        - However, someone would have to maintain this template
        - Also, there may not be much point if QWT/Xen drivers don't work
            - At least for basic features like copy/paste and file transfer
    - Interest from both sides
        - [Qubes OS](https://github.com/QubesOS/qubes-issues/issues/2809)
        - [ReactOS](https://reactos.org/forum/viewtopic.php?p=126279#p126279)
            - "one of the most interesting offers for collaboration we got till today"
    - [ReactOS unattended installations](https://reactos.org/wiki/Create_an_unattended_Installation_CD) look to be different than Windows ones
    - [ ] Only blocking issue I could find is the QEMU SCSI controller type
        - Qubes could extend core admin to support configuring the SCSI controller in the libvirt template
            - This solution seems better because according to [this](https://github.com/QubesOS/qubes-issues/issues/3651#issuecomment-420914348) comment it would also fix a bunch of other OSs whose installer doesn't support our current SCSI controller
        - ReactOS could add support for our current SCSI controller type
        - [ReactOS Issue](https://reactos.org/forum/viewtopic.php?t=17529)
        - [Qubes OS Issue](https://github.com/QubesOS/qubes-issues/issues/3494)
        - Exposing a different SCSI controller does not expand attack surface because QEMU runs in a Xen stub domain
    - ReactOS is in alpha so for most users this probably won't be viable right now
    - Help wanted
        - No timeline for this currently

## End Goal

Have a feature similar (or superior) to [VMWare's Windows "Easy Install"](https://www.youtube.com/watch?v=1OpDXlttmE0) feature on Qubes OS. VMWare's solution is proprietary and only available in their paid products.

VirtualBox also has [something similar](https://blogs.oracle.com/scoter/oracle-vm-virtualbox-52:-unattended-guest-os-install) but it's not as feature-rich.
