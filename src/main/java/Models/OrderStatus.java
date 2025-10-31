/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class OrderStatus {
    private int pending;
    private int processing;
    private int shipped;
    private int delivered;

    public OrderStatus() {
    }

    public OrderStatus(int pending, int processing, int shipped, int delivered) {
        this.pending = pending;
        this.processing = processing;
        this.shipped = shipped;
        this.delivered = delivered;
    }

    public int getPending() {
        return pending;
    }

    public void setPending(int pending) {
        this.pending = pending;
    }

    public int getProcessing() {
        return processing;
    }

    public void setProcessing(int processing) {
        this.processing = processing;
    }

    public int getShipped() {
        return shipped;
    }

    public void setShipped(int shipped) {
        this.shipped = shipped;
    }

    public int getDelivered() {
        return delivered;
    }

    public void setDelivered(int delivered) {
        this.delivered = delivered;
    }
    
    
}
