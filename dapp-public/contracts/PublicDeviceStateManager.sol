pragma solidity ^0.4.6;

import './Ownable.sol';

/**
 * @title DeviceStateManager
 * @dev Manages devices connected to home network 
 */
contract DeviceStateManager is Ownable {

  struct Device {
    bool status;
    uint index;
  }
  
  mapping(address => Device) private devices;
  address[] private deviceIndex;

  event LogNewDevice(address indexed _deviceAddress,
                     uint _index, bool _status);
  event LogDeviceUpdate(address indexed _deviceAddress,
                        uint _index, bool status);
  event LogDeviceOn(address indexed _deviceAddress, uint _index);
  event LogDeviceOff(address indexed _deviceAddress, uint _index);
  event LogDeleteDevice(address indexed _deviceAddress, uint _index);
  
  /**
   * @dev Checks if device is part of home network 
   */
  function isDevice(address _deviceAddress) 
  public 
  constant 
  returns(bool _isIndeed)
  {
    if(deviceIndex.length == 0) return false;
    return (deviceIndex[devices[_deviceAddress].index] == _deviceAddress);
  }
  
  /**
   * @dev Adds device to home network
   */
  function addDevice(address _deviceAddress, bool _status) 
  public 
  onlyOwner 
  returns(uint _index)
  {
    require(!isDevice(_deviceAddress));
    devices[_deviceAddress].status = false;
    devices[_deviceAddress].index = deviceIndex.push(_deviceAddress) - 1;
    emit LogNewDevice(_deviceAddress, devices[_deviceAddress].index, _status);
    return deviceIndex.length - 1;
  }
  
  /**
   * @dev Removes device from the home network
   */
  function deleteDevice(address _deviceAddress)
  public
  onlyOwner
  returns(uint _index)
  {
    require(!isDevice(_deviceAddress)); 
    uint rowToDelete = devices[_deviceAddress].index;
    address keyToMove = deviceIndex[deviceIndex.length - 1];
    deviceIndex[rowToDelete] = keyToMove;
    devices[keyToMove].index = rowToDelete; 
    deviceIndex.length--;
    emit LogDeleteDevice(
        _deviceAddress, 
        rowToDelete);
    emit LogDeviceUpdate(
        keyToMove, 
        rowToDelete, 
        devices[keyToMove].status);
    return rowToDelete;
  }
  
  /**
   * @dev Gets device info provied the device address
   */
  function getDevice(address _deviceAddress)
  public
  constant
  returns(uint _index, bool _status)
  {
    require(!isDevice(_deviceAddress));
    return(
      devices[_deviceAddress].index, 
      devices[_deviceAddress].status);
    
  } 
  
  /**
   * @dev Turn on device
   */
  function turnOnDevice(address _deviceAddress)
  public
  onlyOwner
  returns(bool _success)
  {
    require(!isDevice(_deviceAddress));
    devices[_deviceAddress].status = true;
    emit LogDeviceOn(
      _deviceAddress, 
      devices[_deviceAddress].index);
    return true;
  }
  
  /**
   * @dev Turn off device
   */
  function turnOffDevice(address _deviceAddress)
  public
  onlyOwner
  returns(bool _success)
  {
    require(!isDevice(_deviceAddress));
    devices[_deviceAddress].status = false;
    emit LogDeviceOff(
      _deviceAddress, 
      devices[_deviceAddress].index);
    return true;
  }
  
  /**
   * @dev Get count of devices connected to home network
   */
  function getDeviceCount()
  public
  constant
  returns(uint _count)
  {
    return deviceIndex.length;
  }
  
  /**
   * @dev Get device information provided the device index
   */
  function getDeviceAtIndex(uint _index)
  public
  constant
  returns(address _deviceAddress)
  {
    return deviceIndex[_index];
  }

}