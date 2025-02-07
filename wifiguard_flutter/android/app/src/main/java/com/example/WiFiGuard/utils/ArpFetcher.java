package com.example.WiFiGuard.utils;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class ArpFetcher extends ExecuteAsRootBase {

    public static String getMacAddress(String ip) {
        String macAddress = null;
        try {
            Process suProcess = Runtime.getRuntime().exec("su");
            DataOutputStream os = new DataOutputStream(suProcess.getOutputStream());
            DataInputStream osRes = new DataInputStream(suProcess.getInputStream());

            os.writeBytes("ip neigh show\n");
            os.flush();
            os.writeBytes("exit\n");
            os.flush();
            suProcess.waitFor();

            BufferedReader reader = new BufferedReader(new InputStreamReader(osRes));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains(ip)) {
                    String[] parts = line.split("\\s+");
                    if (parts.length >= 5) {
                        macAddress = parts[3]; // Extract MAC address
                        break;
                    }
                }
            }
            reader.close();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        return macAddress != null ? macAddress : "00:00:00:00:00:00"; // Default if not found
    }

    public static List<String[]> getAllDevices() {
        return new ArpFetcher().getArpTable();
    }

    @Override
    protected ArrayList<String> getCommandsToExecute() {
        ArrayList<String> commands = new ArrayList<>();
        commands.add("ip neigh show");
        return commands;
    }

    public List<String[]> getArpTable() {
        List<String[]> arpEntries = new ArrayList<>();
        try {
            Process suProcess = Runtime.getRuntime().exec("su");
            DataOutputStream os = new DataOutputStream(suProcess.getOutputStream());
            DataInputStream osRes = new DataInputStream(suProcess.getInputStream());

            os.writeBytes("ip neigh show\n");
            os.flush();
            os.writeBytes("exit\n");
            os.flush();
            suProcess.waitFor();

            BufferedReader reader = new BufferedReader(new InputStreamReader(osRes));
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\s+");
                if (parts.length >= 5) {
                    String ip = parts[0];
                    String mac = parts[3];
                    arpEntries.add(new String[]{ip, mac});
                }
            }
            reader.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return arpEntries;
    }
}
