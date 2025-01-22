package com.example.WiFiGuard.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.ArrayList;

public class ArpFetcher extends ExecuteAsRootBase {

    public static String getMacAddress(String ip) {
        String macAddress = null;
        try {
            Process process = Runtime.getRuntime().exec("ip neigh show");
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains(ip)) {
                    String[] parts = line.split("\\s+");
                    if (parts.length >= 5) {
                        macAddress = parts[3];
                        break;
                    }
                }
            }
            reader.close();
        } catch (IOException e) {
            // Handles exceptions
        }
        return macAddress != null ? macAddress : "00:00:00:00:00:00"; // Default if not found
    }

    public static List<String> getAllDevices() {
        return new ArpFetcher().getArpTable();
    }

    @Override
    protected ArrayList<String> getCommandsToExecute() {
        ArrayList<String> commands = new ArrayList<>();
        commands.add("ip neigh show");
        return commands;
    }

    public List<String> getArpTable() {
        List<String> arpEntries = new ArrayList<>();
        try {
            Process suProcess = Runtime.getRuntime().exec("su");
            DataOutputStream os = new DataOutputStream(suProcess.getOutputStream());
            DataInputStream osRes = new DataInputStream(suProcess.getInputStream());
            os.writeBytes("ip neigh show\n");
            os.flush();
            os.writeBytes("exit\n");
            os.flush();
            suProcess.waitFor();

            String line;
            while ((line = osRes.readLine()) != null) {
                arpEntries.add(line);
            }
        } catch (Exception e) {
            // Handles exceptions
        }
        return arpEntries;
    }
}
