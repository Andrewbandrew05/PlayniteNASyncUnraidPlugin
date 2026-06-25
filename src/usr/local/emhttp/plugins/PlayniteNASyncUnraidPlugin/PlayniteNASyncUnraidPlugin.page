Menu="Settings"
Icon="cogs"
Title="Playnite NASync"
Type="xauth"
---
<?php
$cfg_file = "/boot/config/plugins/PlayniteNASyncUnraidPlugin/settings.cfg";
$current_share = '';
$current_password = '';

// Pull existing configurations if they exist
if (file_exists($cfg_file)) {
    $plugin_config = parse_ini_file($cfg_file);
    $current_share = $plugin_config['TARGET_SHARE'] ?? '';
    $current_password = $plugin_config['PASSWORD'] ?? '';
}

// Handle saving when the user clicks 'Apply'
if (isset($_POST['submit']) && $_POST['submit'] === "Apply") {
    $target_share = $_POST['target_share'];
    $password = $_POST['password'];
    
    // Create the directory on the flash drive if it doesn't exist
    if (!is_dir(dirname($cfg_file))) {
        mkdir(dirname($cfg_file), 0777, true);
    }
    
    // Save to a simple config file
    $cfg_content = "TARGET_SHARE=\"$target_share\"\nPASSWORD=\"$password\"\n";
    file_put_contents($cfg_file, $cfg_content);
    
    // Refresh local variables for immediate display
    $current_share = $target_share;
    $current_password = $password;
}
?>

<h2 style="text-align: left;">Current Configuration</h2>
<ul>
    <li><b>Configured Target Share:</b> <?php echo htmlspecialchars($current_share); ?></li>
    <li><b>Configured Password:</b> <?php echo htmlspecialchars($current_password); ?></li>
</ul>

<br><hr><br>

<h2 style="text-align: left;">Modify Settings</h2>
<form method="POST" action="/Settings/PlayniteNASyncUnraidPlugin">
    <table class="settings">
        <tr>
            <td><b>Target Share Name:</b></td>
            <td><input type="text" name="target_share" value="<?php echo htmlspecialchars($current_share); ?>" placeholder="e.g., games_share"></td>
        </tr>
        <tr>
            <td><b>Password:</b></td>
            <td><input type="password" name="password" value="<?php echo htmlspecialchars($current_password); ?>"></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="submit" name="submit" value="Apply"></td>
        </tr>
    </table>
</form>