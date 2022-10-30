function obj = getOptData(optData,obj)

% This function assign optitrack data to rigid body posture coordinates.
% It is considered that the data received is related to the center of
% gravity of the rigid body created.
%
% optData   = Rigid Body structure of the robot
% obj       = Object class variable
% Example: Pioneer, Ardrone, Bebop, Load, Obstacle


if optData.isTracked

    obj.pPos.Xa = obj.pPos.X;  % Save previous data for futher derivative

    % Position [m]
    obj.pPos.X(1:3) = optData.Position/1000;

    % Euler Angles [rad]
    obj.pPos.X(4:6) = -fliplr(quat2eul(optData.Quaternion));


    if obj.pPar.LKF.flag

        % Velocities and angular rates
        obj.pPos.X(7:11) = (obj.pPos.X(1:5)-obj.pPos.Xa(1:5))/obj.pPar.Ts;

        % Yaw rate (Heading)
        if abs(obj.pPos.X(6)-obj.pPos.Xa(6)) > pi
            if obj.pPos.Xa(6) > 0
                obj.pPos.Xa(6) = -2*pi + obj.pPos.Xa(6);
            else
                obj.pPos.Xa(6) =  2*pi + obj.pPos.Xa(6);
            end
        end
        obj.pPos.X(12) = (obj.pPos.X(6)-obj.pPos.Xa(6))/obj.pPar.Ts;

        %         % Linear Kalman filter
        %         GainK = (obj.pPar.LKF.mseOpt + obj.pPar.LKF.varnOpt)\obj.pPar.LKF.mseOpt;
        %         obj.pPar.LKF.xpOtp  = obj.pPar.LKF.xpOpt + GainK*(obj.pPos.X(7:12) - obj.pPar.LKF.xpOtp);
        %         obj.pPar.LKF.mseOpt = (eye(6)-GainK)*obj.pPar.LKF.mseOpt + obj.pPar.LKF.varwOpt;
        %         obj.pPos.X(7:12) = obj.pPar.LKF.xpOtp;

    else
        obj.pPar.LKF.flag = 1;
        obj.pPar.LKF.xpOtp = obj.pPos.X(7:12);
    end


else
    disp('No rigid body tracked!');

end

