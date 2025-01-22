package com.example.WiFiGuard.utils;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public abstract class ExecuteAsRootBase {

    public static boolean canRunRootCommands() {
        try {
            Process suProcess = Runtime.getRuntime().exec("su");
            DataOutputStream os = new DataOutputStream(suProcess.getOutputStream());
            DataInputStream osRes = new DataInputStream(suProcess.getInputStream());

            os.writeBytes("id\n");
            os.flush();

            String currUid = osRes.readLine();
            os.writeBytes("exit\n");
            os.flush();
            suProcess.waitFor();
            return currUid != null && currUid.contains("uid=0");
        } catch (Exception e) {
            return false;
        }
    }

    public final boolean execute() {
        try {
            ArrayList<String> commands = getCommandsToExecute();
            if (commands != null && !commands.isEmpty()) {
                Process suProcess = Runtime.getRuntime().exec("su");
                DataOutputStream os = new DataOutputStream(suProcess.getOutputStream());

                for (String command : commands) {
                    os.writeBytes(command + "\n");
                    os.flush();
                }

                os.writeBytes("exit\n");
                os.flush();
                return suProcess.waitFor() == 0;
            }
        } catch (IOException | InterruptedException e) {
            return false;
        }

        return false;
    }

    protected abstract ArrayList<String> getCommandsToExecute();
}
