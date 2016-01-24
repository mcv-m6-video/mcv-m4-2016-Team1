function [ids, ids_new] = compute_detection_correspondences(KalmanFilters, detections_current)
%% TODO: Post process of ids. If there is some id repeated, then keep the minimum id s.t. d(id,id_kalman) minimum.
ids = zeros(length(KalmanFilters),2);

for k=1:length(KalmanFilters)
    min_distance = inf;
    id = 1;
   for l=1:length(detections_current)
       d = sqrt((KalmanFilters{k}.State(1)-detections_current(l,1))^2+(KalmanFilters{k}.State(2)-detections_current(l,2))^2);
       if d<min_distance
          min_distance = d;
          id = l;
       end
   end
   ids(k,:) = [k,id];
end

end